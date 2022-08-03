package org.egov.wscalculation.service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.egov.wscalculation.constants.WSCalculationConstant;
import org.egov.wscalculation.web.models.TaxHeadEstimate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.minidev.json.JSONArray;

@Service
public class PayService {

	@Autowired
	private MasterDataService mDService;
	
	@Autowired
	private EstimationService estimationService;

	/**
	 * Decimal is ceiled for all the tax heads
	 * 
	 * if the decimal is greater than 0.5 upper bound will be applied
	 * 
	 * else if decimal is lesser than 0.5 lower bound is applied
	 * 
	 */
	public TaxHeadEstimate roundOfDecimals(BigDecimal creditAmount, BigDecimal debitAmount, boolean isConnectionFee) {
		BigDecimal roundOffPos = BigDecimal.ZERO;
		BigDecimal roundOffNeg = BigDecimal.ZERO;
        String taxHead = isConnectionFee ? WSCalculationConstant.WS_Round_Off : WSCalculationConstant.WS_ONE_TIME_FEE_ROUND_OFF;
		BigDecimal result = creditAmount.add(debitAmount);
		BigDecimal roundOffAmount = result.setScale(2, 2);
		BigDecimal reminder = roundOffAmount.remainder(BigDecimal.ONE);

		if (reminder.doubleValue() >= 0.5)
			roundOffPos = roundOffPos.add(BigDecimal.ONE.subtract(reminder));
		else if (reminder.doubleValue() < 0.5)
			roundOffNeg = roundOffNeg.add(reminder).negate();

		if (roundOffPos.doubleValue() > 0)
			return TaxHeadEstimate.builder().estimateAmount(roundOffPos).taxHeadCode(taxHead)
					.build();
		else if (roundOffNeg.doubleValue() < 0)
			return TaxHeadEstimate.builder().estimateAmount(roundOffNeg).taxHeadCode(taxHead)
					.build();
		else
			return null;
	}
	
	/**
	 * 
	 * @param waterCharge - Water Charge Amount
	 * @param assessmentYear - Assessment Year
	 * @param timeBasedExemptionMasterMap - Time Based Exemption Master Data
	 * @param billingExpiryDate - Billing Expiry Date
	 * @return estimation of time based exemption
	 */
	public Map<String, BigDecimal> applyPenaltyRebateAndInterest(BigDecimal waterCharge,
			String assessmentYear, Map<String, JSONArray> timeBasedExemptionMasterMap, Long billingExpiryDate, BigDecimal currentMonthDemand, boolean isGetPenaltyEstimate) {

		if (BigDecimal.ZERO.compareTo(waterCharge) >= 0)
			return Collections.emptyMap();
		Map<String, BigDecimal> estimates = new HashMap<>();
		long currentUTC = System.currentTimeMillis();
		long numberOfDaysInMillis = billingExpiryDate - currentUTC;
		BigDecimal noOfDays = BigDecimal.valueOf((TimeUnit.MILLISECONDS.toDays(Math.abs(numberOfDaysInMillis))));
		if(BigDecimal.ONE.compareTo(noOfDays) <= 0) noOfDays = noOfDays.add(BigDecimal.ONE);
		Map<String, BigDecimal> penaltyType = getApplicablePenalty(waterCharge, noOfDays, timeBasedExemptionMasterMap.get(WSCalculationConstant.WC_PENANLTY_MASTER),currentMonthDemand,isGetPenaltyEstimate);
		BigDecimal interest = getApplicableInterest(waterCharge, noOfDays, timeBasedExemptionMasterMap.get(WSCalculationConstant.WC_INTEREST_MASTER));
		if(penaltyType.containsKey("outstanding")) {
			estimates.put("outstanding", penaltyType.get("outstanding").setScale(2, 2));
		}
		else {
			estimates.put("currentMonth", penaltyType.get("currentMonth").setScale(2, 2));
		}
		estimates.put(WSCalculationConstant.WS_TIME_INTEREST, interest.setScale(2, 2));
		return estimates;
	}

	/**
	 * Returns the Amount of penalty that has to be applied on the given tax amount for the given period
	 * 
	 * @param taxAmt - Tax Amount
	 * @param assessmentYear - Assessment Year
	 * @return applicable penalty for given time
	 */
	public BigDecimal getPenalty(BigDecimal taxAmt, String assessmentYear, JSONArray penaltyMasterList, BigDecimal noOfDays) {

		BigDecimal penaltyAmt = BigDecimal.ZERO;
		Map<String, Object> penalty = mDService.getApplicableMaster(assessmentYear, penaltyMasterList);
		if (null == penalty) return penaltyAmt;
			penaltyAmt = mDService.calculateApplicable(taxAmt, penalty);
		return penaltyAmt;
	}
	
	/**
	 * 
	 * @param waterCharge - Water Charge amount
	 * @param noOfDays - No.Of.Days
	 * @param config
	 *            master configuration
	 * @return applicable penalty
	 */
	public Map<String, BigDecimal> getApplicablePenalty(BigDecimal waterCharge, BigDecimal noOfDays, JSONArray config, BigDecimal currentMonthDemand, boolean isGetPenaltyEstimate) {
		Map<String, BigDecimal> penaltyType = new HashMap<>();

		BigDecimal applicablePenalty = BigDecimal.ZERO;
		Map<String, Object> penaltyMaster = mDService.getApplicableMaster(estimationService.getAssessmentYear(), config);

		String type = (String) penaltyMaster.get(WSCalculationConstant.TYPE_FIELD_NAME);
		String subType = (String) penaltyMaster.get(WSCalculationConstant.SUBTYPE_FIELD_NAME);
		
		if (null == penaltyMaster) {
			penaltyType.put(subType, applicablePenalty);
			return penaltyType;
		}
		BigDecimal daysApplicable = null != penaltyMaster.get(WSCalculationConstant.DAYS_APPLICABLE_NAME)
				? BigDecimal.valueOf(((Number) penaltyMaster.get(WSCalculationConstant.DAYS_APPLICABLE_NAME)).intValue())
				: null;
		if (daysApplicable == null) {
			penaltyType.put(subType, applicablePenalty);
			return penaltyType;	
		}
			
		if(!isGetPenaltyEstimate) {
			BigDecimal daysDiff = noOfDays.subtract(daysApplicable);
			if (daysDiff.compareTo(BigDecimal.ONE) < 0) {
				penaltyType.put(subType, applicablePenalty);
				return penaltyType;
			}
		}
		
		
		BigDecimal rate = null != penaltyMaster.get(WSCalculationConstant.RATE_FIELD_NAME)
				? BigDecimal.valueOf(((Number) penaltyMaster.get(WSCalculationConstant.RATE_FIELD_NAME)).doubleValue())
				: null;

		BigDecimal flatAmt = null != penaltyMaster.get(WSCalculationConstant.FLAT_AMOUNT_FIELD_NAME)
				? BigDecimal
						.valueOf(((Number) penaltyMaster.get(WSCalculationConstant.FLAT_AMOUNT_FIELD_NAME)).doubleValue())
				: BigDecimal.ZERO;
		
		BigDecimal amount = null != penaltyMaster.get(WSCalculationConstant.AMOUNT_FIELD_NAME)
				? BigDecimal
						.valueOf(((Number) penaltyMaster.get(WSCalculationConstant.AMOUNT_FIELD_NAME)).doubleValue())
				: null;
		
		if(subType.equalsIgnoreCase("outstanding")) {
			applicablePenalty = calculateApplicablePenaltyAmount(waterCharge, type, rate, flatAmt, amount);
		}
		if(subType.equalsIgnoreCase("currentMonth") && (currentMonthDemand.compareTo(BigDecimal.ZERO))>0) {
			applicablePenalty = calculateApplicablePenaltyAmount(currentMonthDemand, type, rate, flatAmt, amount);
		}
		
		penaltyType.put(subType, applicablePenalty);
		return penaltyType;
	}

	private BigDecimal calculateApplicablePenaltyAmount(BigDecimal waterCharge, String type, BigDecimal rate,
			BigDecimal flatAmt, BigDecimal amount) {
		BigDecimal applicablePenalty = BigDecimal.ZERO;
		if(type.equalsIgnoreCase("FIXED") && rate != null) {
			applicablePenalty = waterCharge.multiply(rate.divide(WSCalculationConstant.HUNDRED));
		}
		if(type.equalsIgnoreCase("FLAT") && amount != null) {
			applicablePenalty = amount;
		}
//		else {
//			applicablePenalty = flatAmt.compareTo(waterCharge) > 0 ? BigDecimal.ZERO : flatAmt;
//		}
		return applicablePenalty;
	}
	
	/**
	 * 
	 * @param waterCharge - Water Charge
	 * @param noOfDays - No.Of Days value
	 * @param config
	 *            master configuration
	 * @return applicable Interest
	 */
	public BigDecimal getApplicableInterest(BigDecimal waterCharge, BigDecimal noOfDays, JSONArray config) {
		BigDecimal applicableInterest = BigDecimal.ZERO;
		Map<String, Object> interestMaster = mDService.getApplicableMaster(estimationService.getAssessmentYear(), config);
		if (null == interestMaster) return applicableInterest;
		BigDecimal daysApplicable = null != interestMaster.get(WSCalculationConstant.DAYS_APPLICABLE_NAME)
				? BigDecimal.valueOf(((Number) interestMaster.get(WSCalculationConstant.DAYS_APPLICABLE_NAME)).intValue())
				: null;
		if (daysApplicable == null)
			return applicableInterest;
		BigDecimal daysDiff = noOfDays.subtract(daysApplicable);
		if (daysDiff.compareTo(BigDecimal.ONE) < 0) {
			return applicableInterest;
		}
		BigDecimal rate = null != interestMaster.get(WSCalculationConstant.RATE_FIELD_NAME)
				? BigDecimal.valueOf(((Number) interestMaster.get(WSCalculationConstant.RATE_FIELD_NAME)).doubleValue())
				: null;

		BigDecimal flatAmt = null != interestMaster.get(WSCalculationConstant.FLAT_AMOUNT_FIELD_NAME)
				? BigDecimal
						.valueOf(((Number) interestMaster.get(WSCalculationConstant.FLAT_AMOUNT_FIELD_NAME)).doubleValue())
				: BigDecimal.ZERO;

		if (rate == null)
			applicableInterest = flatAmt.compareTo(waterCharge) > 0 ? BigDecimal.ZERO : flatAmt;
		else{
			// rate of interest
			applicableInterest = waterCharge.multiply(rate.divide(WSCalculationConstant.HUNDRED));
		}
		//applicableInterest.multiply(noOfDays.divide(BigDecimal.valueOf(365), 6, 5));
		return applicableInterest;
	}
}
