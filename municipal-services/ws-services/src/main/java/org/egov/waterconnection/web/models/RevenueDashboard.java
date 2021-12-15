package org.egov.waterconnection.web.models;


import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RevenueDashboard {

	@JsonProperty("demand")
	private String demand = "0";

	@JsonProperty("pendingCollection")
	private String pendingCollection = "0";

	@JsonProperty("actualCollection")
	private String actualCollection = "0";

	@JsonProperty("residetialColllection")
	private String residetialColllection = "0";

	@JsonProperty("comercialCollection")
	private String comercialCollection = "0";

	@JsonProperty("othersCollection")
	private String othersCollection = "0";

	@JsonProperty("totalApplicationsCount")
	private String totalApplicationsCount = "0";

	@JsonProperty("residentialsCount")
	private String residentialsCount = "0";

	@JsonProperty("comercialsCount")
	private String comercialsCount = "0";

}
