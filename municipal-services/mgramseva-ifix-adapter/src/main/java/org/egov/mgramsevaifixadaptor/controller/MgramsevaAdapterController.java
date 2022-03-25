package org.egov.mgramsevaifixadaptor.controller;

import java.util.List;

import javax.validation.Valid;

import org.egov.mgramsevaifixadaptor.config.PropertyConfiguration;
import org.egov.mgramsevaifixadaptor.contract.DemandRequest;
import org.egov.mgramsevaifixadaptor.models.Demand;
import org.egov.mgramsevaifixadaptor.models.DemandResponse;
import org.egov.mgramsevaifixadaptor.models.RequestInfoWrapper;
import org.egov.mgramsevaifixadaptor.models.SearchCriteria;
import org.egov.mgramsevaifixadaptor.producer.Producer;
import org.egov.mgramsevaifixadaptor.service.AdopterService;
import org.egov.mgramsevaifixadaptor.util.ResponseInfoFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/mGramsevaAdopter/v1")
public class MgramsevaAdapterController {

	@Autowired
	private ResponseInfoFactory responseInfoFactory;

	@Autowired
	AdopterService adopterService;
	
	@Autowired
	Producer producer;

	@Autowired
	private PropertyConfiguration config;
	
	

	@RequestMapping(value = "/_legacydatatransfer", method = RequestMethod.POST)
	public ResponseEntity<DemandResponse> planeSearch(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper,
			@Valid @ModelAttribute SearchCriteria criteria) {
		List<Demand> demands = adopterService.legecyDemand(criteria, requestInfoWrapper.getRequestInfo());
		DemandResponse response = new DemandResponse();
		if (!demands.isEmpty() && demands.size() > 0) {
			DemandRequest demandRequest = new DemandRequest();
			demandRequest.setRequestInfo(requestInfoWrapper.getRequestInfo());
			for (Demand demand : demands) {
				demandRequest.getDemands().add(demand);
				producer.push(config.getCreateLegacyDemandTopic(), demandRequest);
			}
			
			response = DemandResponse.builder().demands(demands).responseInfo(
					responseInfoFactory.createResponseInfoFromRequestInfo(requestInfoWrapper.getRequestInfo(), true))
					.build();
		}
		return new ResponseEntity<>(response, HttpStatus.OK);
	}
}
