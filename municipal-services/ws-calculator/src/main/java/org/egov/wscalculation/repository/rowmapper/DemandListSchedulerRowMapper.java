package org.egov.wscalculation.repository.rowmapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.stereotype.Component;

@Component
public class DemandListSchedulerRowMapper implements ResultSetExtractor<Map<String, String>> {

	@Override
	public Map<String, String> extractData(ResultSet rs) throws SQLException, DataAccessException {
		Map<String, String> connectionAndConsumerTypeLists = new HashMap<>();

		while (rs.next()) {
			connectionAndConsumerTypeLists.put(rs.getString("connectionno"), rs.getString("paymenttype"));
		}
		return connectionAndConsumerTypeLists;
	}
}