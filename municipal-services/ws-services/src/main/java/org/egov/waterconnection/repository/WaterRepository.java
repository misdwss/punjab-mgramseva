package org.egov.waterconnection.repository;

import java.util.List;
import java.util.Map;

import org.egov.waterconnection.repository.builder.WsQueryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Repository
public class WaterRepository {

	
	@Autowired
	private WsQueryBuilder queryBuilder;

	@Autowired
    private JdbcTemplate jdbcTemplate;
	
	public List<String> getTenantId() {
		String query = queryBuilder.getDistinctTenantIds();
		log.info("Tenants List Query : " + query);
		return jdbcTemplate.queryForList(query, String.class);
	}


	public List<String> getPendingCollection(String tenantId, String startDate, String endDate) {
		StringBuilder query = new StringBuilder(WsQueryBuilder.PENDINGCOLLECTION);
		query.append(" and demand.tenantid = '").append(tenantId).append("'")
		.append( " and taxperiodfrom  >= ").append( startDate)  
		.append(" and  taxperiodto <= " ).append(endDate);
		log.info("Active pending collection query : " + query);
		return jdbcTemplate.queryForList(query.toString(), String.class);
		
	}


	public Integer getPreviousMonthExpensePayments(String tenantId, Long startDate, Long endDate) {
		StringBuilder query = new StringBuilder(WsQueryBuilder.PREVIOUSMONTHEXPPAYMENT);
		
		//previous month start date startDate
		// previous month end date endDate
		
		query.append( " and PAYMTDTL.receiptdate  >= ").append( startDate)  
		.append(" and  PAYMTDTL.receiptdate <= " ).append(endDate); 
		log.info("Previous month expense paid query : " + query);
		return jdbcTemplate.queryForObject(query.toString(), Integer.class);
	}


	public List<String> getPreviousMonthExpenseExpenses(String tenantId, String startDate, String endDate) {
		StringBuilder query = new StringBuilder(queryBuilder.PREVIOUSMONTHEXPENSE);

		query.append(" and challan.paiddate  >= ").append(startDate).append(" and  challan.paiddate <= ")
				.append(endDate);
		log.info("Previous month expense query : " + query);
		return jdbcTemplate.queryForList(query.toString(), String.class);
	}


	public List<Map<String, Object>> getTodayCollection(String tenantId, String startDate, String endDate, String mode) {
		StringBuilder query = new StringBuilder();
		if(mode.equalsIgnoreCase("CASH")) {
		 query = new StringBuilder(queryBuilder.PREVIOUSDAYCASHCOLLECTION);
		}else {
			query = new StringBuilder(queryBuilder.PREVIOUSDAYONLINECOLLECTION);
		}
		query.append( " and transactiondate  >= ").append( startDate)  
		.append(" and  transactiondate <= " ).append(endDate); 
		log.info("Previous Day collection query : " + query);
		List<Map<String, Object>> list =  jdbcTemplate.queryForList(query.toString());
		return list;
	}
	


}
