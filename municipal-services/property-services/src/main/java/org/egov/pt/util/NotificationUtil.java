package org.egov.pt.util;


import static org.egov.pt.util.PTConstants.ASMT_USER_EVENT_PAY;
import static org.egov.pt.util.PTConstants.NOTIFICATION_LOCALE;
import static org.egov.pt.util.PTConstants.NOTIFICATION_MODULENAME;
import static org.egov.pt.util.PTConstants.NOTIFICATION_OWNERNAME;
import static org.egov.pt.util.PTConstants.NOTIFICATION_EMAIL;
import static org.egov.pt.util.PTConstants.PT_BUSINESSSERVICE;
import static org.egov.pt.util.PTConstants.PT_CORRECTION_PENDING;
import static org.egov.pt.util.PTConstants.USREVENTS_EVENT_NAME;
import static org.egov.pt.util.PTConstants.USREVENTS_EVENT_POSTEDBY;
import static org.egov.pt.util.PTConstants.USREVENTS_EVENT_TYPE;
import static org.egov.pt.util.PTConstants.VIEW_APPLICATION_CODE;

import java.util.*;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.egov.common.contract.request.RequestInfo;
import org.egov.pt.config.PropertyConfiguration;
import org.egov.pt.models.Property;
import org.egov.pt.models.enums.CreationReason;
import org.egov.pt.models.event.Action;
import org.egov.pt.models.event.ActionItem;
import org.egov.pt.models.event.Event;
import org.egov.pt.models.event.EventRequest;
import org.egov.pt.models.event.Recepient;
import org.egov.pt.models.event.Source;
import org.egov.pt.producer.Producer;
import org.egov.pt.repository.ServiceRequestRepository;
import org.egov.pt.web.contracts.Email;
import org.egov.pt.web.contracts.EmailRequest;
import org.egov.pt.web.contracts.EmailRequest;

import org.egov.pt.web.contracts.SMSRequest;
import org.egov.tracer.model.CustomException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.web.client.RestTemplate;

import com.jayway.jsonpath.JsonPath;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Component
public class NotificationUtil {



    private ServiceRequestRepository serviceRequestRepository;

    private PropertyConfiguration config;

    private Producer producer;

    private RestTemplate restTemplate;

    @Autowired
    public NotificationUtil(ServiceRequestRepository serviceRequestRepository, PropertyConfiguration config,
                            Producer producer, RestTemplate restTemplate) {
        this.serviceRequestRepository = serviceRequestRepository;
        this.config = config;
        this.producer = producer;
        this.restTemplate = restTemplate;
    }





    /**
     * Extracts message for the specific code
     *
     * @param notificationCode
     *            The code for which message is required
     * @param localizationMessage
     *            The localization messages
     * @return message for the specific code
     */
    public String getMessageTemplate(String notificationCode, String localizationMessage) {

        String path = "$..messages[?(@.code==\"{}\")].message";
        path = path.replace("{}", notificationCode);
        String message = "";
        try {
            Object messageObj = JsonPath.parse(localizationMessage).read(path);
            message = ((ArrayList<String>) messageObj).get(0);
        } catch (Exception e) {
            log.warn("Fetching from localization failed", e);
        }
        return message;
    }



    /**
     * Fetches messages from localization service
     *
     * @param tenantId
     *            tenantId of the PT
     * @param requestInfo
     *            The requestInfo of the request
     * @return Localization messages for the module
     */
    public String getLocalizationMessages(String tenantId, RequestInfo requestInfo) {
    	
        String locale = NOTIFICATION_LOCALE;
        Boolean isRetryNeeded = false;
        String jsonString = null;
        LinkedHashMap responseMap = null;

        if (!StringUtils.isEmpty(requestInfo.getMsgId()) && requestInfo.getMsgId().split("\\|").length >= 2) {
            locale = requestInfo.getMsgId().split("\\|")[1];
			isRetryNeeded = true;
		}

		responseMap = (LinkedHashMap) serviceRequestRepository.fetchResult(getUri(tenantId, requestInfo, locale), requestInfo).get();
		jsonString = new JSONObject(responseMap).toString();

		if (StringUtils.isEmpty(jsonString) && isRetryNeeded) {

			responseMap = (LinkedHashMap) serviceRequestRepository.fetchResult(getUri(tenantId, requestInfo, NOTIFICATION_LOCALE), requestInfo).get();
			jsonString = new JSONObject(responseMap).toString();
			if(StringUtils.isEmpty(jsonString))
				throw new CustomException("EG_PT_LOCALE_ERROR","Localisation values not found for Property notifications");
		}
		return jsonString;
	}


    /**
     * Returns the uri for the localization call
     *
     * @param tenantId
     *            TenantId of the propertyRequest
     * @return The uri for localization search call
     */
    public StringBuilder getUri(String tenantId, RequestInfo requestInfo, String locale) {

        if (config.getIsLocalizationStateLevel())
            tenantId = tenantId.split("\\.")[0];

        StringBuilder uri = new StringBuilder();
        uri.append(config.getLocalizationHost()).append(config.getLocalizationContextPath())
                .append(config.getLocalizationSearchEndpoint()).append("?").append("locale=").append(locale)
                .append("&tenantId=").append(tenantId).append("&module=").append(NOTIFICATION_MODULENAME);

        return uri;
    }


    /**
     * Creates sms request for the each owners
     *
     * @param message
     *            The message for the specific tradeLicense
     * @param mobileNumberToOwnerName
     *            Map of mobileNumber to OwnerName
     * @return List of SMSRequest
     */
    public List<SMSRequest> createSMSRequest(String message, Map<String, String> mobileNumberToOwnerName) {
    	
        List<SMSRequest> smsRequest = new LinkedList<>();
        for (Map.Entry<String, String> entryset : mobileNumberToOwnerName.entrySet()) {
            String customizedMsg = message.replace(NOTIFICATION_OWNERNAME, entryset.getValue());
            smsRequest.add(new SMSRequest(entryset.getKey(), customizedMsg));
        }
        return smsRequest;
    }


    /**
     * Send the SMSRequest on the SMSNotification kafka topic
     *
     * @param smsRequestList
     *            The list of SMSRequest to be sent
     */
    public void sendSMS(List<SMSRequest> smsRequestList) {
    	
        if (config.getIsSMSNotificationEnabled()) {
            if (CollectionUtils.isEmpty(smsRequestList))
                log.info("Messages from localization couldn't be fetched!");
            for (SMSRequest smsRequest : smsRequestList) {
                producer.push(config.getSmsNotifTopic(), smsRequest);
                log.info("Sending SMS notification: ");
                log.info("MobileNumber: " + smsRequest.getMobileNumber() + " Messages: " + smsRequest.getMessage());
            }
        }
    }


    /**
     * Fetches UUIDs of CITIZENs based on the phone number.
     *
     * @param mobileNumbers
     * @param requestInfo
     * @param tenantId
     * @return
     */
    public Map<String, String> fetchUserUUIDs(Set<String> mobileNumbers, RequestInfo requestInfo, String tenantId) {
    	
        Map<String, String> mapOfPhnoAndUUIDs = new HashMap<>();
        StringBuilder uri = new StringBuilder();
        uri.append(config.getUserHost()).append(config.getUserSearchEndpoint());
        Map<String, Object> userSearchRequest = new HashMap<>();
        userSearchRequest.put("RequestInfo", requestInfo);
        userSearchRequest.put("tenantId", tenantId);
        userSearchRequest.put("userType", "CITIZEN");
        for(String mobileNo: mobileNumbers) {
            userSearchRequest.put("userName", mobileNo);
            try {
                Object user = serviceRequestRepository.fetchResult(uri, userSearchRequest).get();
                if(null != user) {
                    String uuid = JsonPath.read(user, "$.user[0].uuid");
                    mapOfPhnoAndUUIDs.put(mobileNo, uuid);
                }else {
                    log.error("Service returned null while fetching user for username - "+mobileNo);
                }
            }catch(Exception e) {
                log.error("Exception while fetching user for username - "+mobileNo);
                log.error("Exception trace: ",e);
                continue;
            }
        }
        return mapOfPhnoAndUUIDs;
    }

    /**
     * Pushes the event request to Kafka Queue.
     *
     * @param request
     */
    public void sendEventNotification(EventRequest request) {
        log.info("EVENT notification sent!");
        producer.push(config.getSaveUserEventsTopic(), request);
    }


    /**
     * Creates email request for the each owners
     *
     * @param message
     *            The message for the specific tradeLicense
     * @param mobileNumberToEmailId
     *            Map of mobileNumber to emailIds
     * @return List of EmailRequest
     */

    public List<EmailRequest> createEmailRequest(RequestInfo requestInfo,String message, Map<String, String> mobileNumberToEmailId) {

        List<EmailRequest> emailRequest = new LinkedList<>();
        for (Map.Entry<String, String> entryset : mobileNumberToEmailId.entrySet()) {
            String customizedMsg = message.replace(NOTIFICATION_EMAIL, entryset.getValue());
            String subject = customizedMsg.substring(customizedMsg.indexOf("<h2>")+4,customizedMsg.indexOf("</h2>"));
            String body = customizedMsg.substring(customizedMsg.indexOf("</h2>")+4);
            Email emailobj = Email.builder().emailTo(Collections.singleton(entryset.getValue())).isHTML(true).body(body).subject(subject).build();
            EmailRequest email = new EmailRequest(requestInfo,emailobj);
            emailRequest.add(email);
        }
        return emailRequest;
    }


    /**
     * Send the EmailRequest on the EmailNotification kafka topic
     *
     * @param emailRequestList
     *            The list of EmailRequest to be sent
     */
    public void sendEmail(List<EmailRequest> emailRequestList) {

        if (config.getIsEmailNotificationEnabled()) {
            if (CollectionUtils.isEmpty(emailRequestList))
                log.info("Messages from localization couldn't be fetched!");
            for (EmailRequest emailRequest : emailRequestList) {
                producer.push(config.getEmailNotifTopic(), emailRequest);
                log.info("Sending EMAIL notification: ");
                log.info("Email Id: " + emailRequest.getEmail().toString());
            }
        }
    }

    /**
     * Fetches email ids of CITIZENs based on the phone number.
     *
     * @param mobileNumbers
     * @param requestInfo
     * @param tenantId
     * @return
     */

    public Map<String, String> fetchUserEmailIds(Set<String> mobileNumbers, RequestInfo requestInfo, String tenantId) {
        Map<String, String> mapOfPhnoAndEmailIds = new HashMap<>();
        StringBuilder uri = new StringBuilder();
        uri.append(config.getUserHost()).append(config.getUserSearchEndpoint());
        Map<String, Object> userSearchRequest = new HashMap<>();
        userSearchRequest.put("RequestInfo", requestInfo);
        userSearchRequest.put("tenantId", tenantId);
        userSearchRequest.put("userType", "CITIZEN");
        for(String mobileNo: mobileNumbers) {
            userSearchRequest.put("userName", mobileNo);
            try {
                Object user = serviceRequestRepository.fetchResult(uri, userSearchRequest).get();
                if(null != user) {
                    if(JsonPath.read(user, "$.user[0].emailId")!=null) {
                        String email = JsonPath.read(user, "$.user[0].emailId");
                    mapOfPhnoAndEmailIds.put(mobileNo, email);
                    }
                }else {
                    log.error("Service returned null while fetching user for username - "+mobileNo);
                }
            }catch(Exception e) {
                log.error("Exception while fetching user for username - "+mobileNo);
                log.error("Exception trace: ",e);
                continue;
            }
        }
        return mapOfPhnoAndEmailIds;
    }
    /**
     * Method to shortent the url
     * returns the same url if shortening fails 
     * @param url
     */
    public String getShortenedUrl(String url){
    	
        HashMap<String,String> body = new HashMap<>();
        body.put("url",url);
        StringBuilder builder = new StringBuilder(config.getUrlShortnerHost());
        builder.append(config.getUrlShortnerEndpoint());
        String res = restTemplate.postForObject(builder.toString(), body, String.class);

        if(StringUtils.isEmpty(res)){
            log.error("URL_SHORTENING_ERROR","Unable to shorten url: "+url); ;
            return url;
        }
        else return res;
    }
    
    /**
    *
    * @param request
    * @param smsRequests
    * @param events
    */
   public List<Event> enrichEvent(List<SMSRequest> smsRequests, RequestInfo requestInfo, String tenantId, Property property, Boolean isActionReq){

		List<Event> events = new ArrayList<>();
       Set<String> mobileNumbers = smsRequests.stream().map(SMSRequest :: getMobileNumber).collect(Collectors.toSet());
       Map<String, String> mapOfPhnoAndUUIDs = fetchUserUUIDs(mobileNumbers, requestInfo, tenantId);
       if (CollectionUtils.isEmpty(mapOfPhnoAndUUIDs.keySet())) {
           log.error("UUIDs Not found for Mobilenumbers");
       }
       
       Map<String,String > mobileNumberToMsg = smsRequests.stream().collect(Collectors.toMap(SMSRequest::getMobileNumber, SMSRequest::getMessage));
       mobileNumbers.forEach(mobileNumber -> {
       	
           List<String> toUsers = new ArrayList<>();
           toUsers.add(mapOfPhnoAndUUIDs.get(mobileNumber));
           Recepient recepient = Recepient.builder().toUsers(toUsers).toRoles(null).build();

           Action action = null;
           if(isActionReq){
               List<ActionItem> items = new ArrayList<>();
               String msg = smsRequests.get(0).getMessage();
               String actionLink = "";
               if(msg.contains(PT_CORRECTION_PENDING)){
            	   
					String url = config.getUserEventViewPropertyLink();
					if (property.getCreationReason().equals(CreationReason.MUTATION)) {
						url = config.getUserEventViewMutationLink();
					}
					
                   actionLink = url.replace("$mobileNo", mobileNumber)
                           .replace("$tenantId", tenantId)
                           .replace("$propertyId" , property.getPropertyId())
                           .replace("$applicationNumber" , property.getAcknowldgementNumber());

                   actionLink = config.getUiAppHost() + actionLink;
                   ActionItem item = ActionItem.builder().actionUrl(actionLink).code(VIEW_APPLICATION_CODE).build();
                   items.add(item);
               }

               if(msg.contains(ASMT_USER_EVENT_PAY)){
                   actionLink = config.getPayLink().replace("$mobile", mobileNumber)
                           .replace("$propertyId", property.getPropertyId())
                           .replace("$tenantId", property.getTenantId())
                           .replace("$businessService" , PT_BUSINESSSERVICE);

                   actionLink = config.getUiAppHost() + actionLink;
                   ActionItem item = ActionItem.builder().actionUrl(actionLink).code(config.getPayCode()).build();
                   items.add(item);
               }


               action = Action.builder().actionUrls(items).build();

           }
           events.add(Event.builder().tenantId(tenantId).description(mobileNumberToMsg.get(mobileNumber))
                   .eventType(USREVENTS_EVENT_TYPE).name(USREVENTS_EVENT_NAME)
                   .postedBy(USREVENTS_EVENT_POSTEDBY).source(Source.WEBAPP).recepient(recepient)
                   .eventDetails(null).actions(action).build());

		});
		return events;
	}

}
