package org.egov.mgramsevaifixadaptor.consumer;

import java.math.BigDecimal;
import java.text.Bidi;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egov.mgramsevaifixadaptor.config.PropertyConfiguration;
import org.egov.mgramsevaifixadaptor.contract.DemandRequest;
import org.egov.mgramsevaifixadaptor.models.AuditDetails;
import org.egov.mgramsevaifixadaptor.models.Bill.StatusEnum;
import org.egov.mgramsevaifixadaptor.models.Demand;
import org.egov.mgramsevaifixadaptor.models.DemandDetail;
import org.egov.mgramsevaifixadaptor.models.EventTypeEnum;
import org.egov.mgramsevaifixadaptor.util.Constants;
import org.egov.mgramsevaifixadaptor.util.MgramasevaAdapterWrapperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class MgramsevaAdapterDemandConsumer {

	@Autowired
	MgramasevaAdapterWrapperUtil util;
	
	@Autowired
	JdbcTemplate jdbcTemplate;
	
	@KafkaListener(topics = { "${kafka.topics.create.demand}", "${kafka.topics.save.legacy.demand}"})
	public void listen(final HashMap<String, Object> record, @Header(KafkaHeaders.RECEIVED_TOPIC) String topic) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		DemandRequest demandRequest=null;
		log.info("crate demand topic");
		try {
			log.debug("Consuming record: " + record);
			demandRequest = mapper.convertValue(record, DemandRequest.class);
			String eventType=null;
			if(demandRequest.getDemands().get(0).getBusinessService().contains(Constants.EXPENSE))
			{
				eventType=EventTypeEnum.BILL.toString();
			}else {
				eventType=EventTypeEnum.DEMAND.toString();
			}
				
			util.callIFIXAdapter(demandRequest, eventType, demandRequest.getDemands().get(0).getTenantId(),demandRequest.getRequestInfo());
		} catch (final Exception e) {
			log.error("Error while listening to value: " + record + " on topic: " + topic + ": " + e);
		}
		
		 //TODO enable after implementation
	}
	
	@KafkaListener(topics = { "${kafka.topics.update.demand}"})
	public void listenUpdate(final HashMap<String, Object> record, @Header(KafkaHeaders.RECEIVED_TOPIC) String topic) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		DemandRequest demandRequest=null;
		log.info("update demand topic");
		try {
			log.debug("Consuming record: " + record);
			demandRequest = mapper.convertValue(record, DemandRequest.class);
			log.info("demandRequest before: "+new Gson().toJson(demandRequest));
			String eventType=null;
			if(demandRequest != null) {
				Collections.sort(demandRequest.getDemands(), getCreatedTimeComparatorForDemand());
				if(demandRequest.getDemands().get(0).getStatus().toString().equalsIgnoreCase(Constants.CANCELLED)) {
					BigDecimal totalAmount = new BigDecimal(0.00);
					if(demandRequest.getDemands().get(0).getDemandDetails() != null) {
						for(DemandDetail dd : demandRequest.getDemands().get(0).getDemandDetails()) {
							totalAmount = totalAmount.add(dd.getTaxAmount());
						}
						totalAmount = totalAmount.negate();
						int demandDetailsSize = demandRequest.getDemands().get(0).getDemandDetails().size();
						for(int i=0; i<demandDetailsSize-1; i++) {
							demandRequest.getDemands().get(0).getDemandDetails().remove(0);
						}
						demandRequest.getDemands().get(0).getDemandDetails().get(0).setTaxAmount(totalAmount);
					}
				}else {
					
					for(Demand demand : demandRequest.getDemands()) {
						List<DemandDetail> demandDetails = demand.getDemandDetails();
						for(DemandDetail demandDetail: demandDetails) {
							
							Integer count =  getCountByDemandDetailsId(demandDetail.getId());
							
							if(count != null && count > 1) {
								demandDetails.remove(demandDetail);
							}
							
						}
					}
					
					log.info("demandRequest after: "+new Gson().toJson(demandRequest));
				}
			}
			if(demandRequest.getDemands().get(0).getBusinessService().contains(Constants.EXPENSE))
			{
				eventType=EventTypeEnum.BILL.toString();
			}else {
				eventType=EventTypeEnum.DEMAND.toString();
			}
			log.info("calling ifix-reference-adapter util");

			util.callIFIXAdapter(demandRequest, eventType, demandRequest.getDemands().get(0).getTenantId(),demandRequest.getRequestInfo());
		} catch (final Exception e) {
			log.error("Error while listening to value: " + record + " on topic: " + topic + ": " + e);
		}
	}
	
	public static Comparator<Demand> getCreatedTimeComparatorForDemand() {
		return new Comparator<Demand>() {
			@Override
			public int compare(Demand o1, Demand o2) {
				return o2.getAuditDetails().getCreatedTime().compareTo(o1.getAuditDetails().getCreatedTime());
			}
		};
	}
	
	public Integer getCountByDemandDetailsId(String demanddetailid) {  
		String sql = "SELECT count(*) FROM egbs_demanddetail_v1_audit WHERE demanddetailid = '"+demanddetailid+"' ";
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
		System.out.println("count: "+count);
		return count;
	}

}
