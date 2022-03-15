/**
 * Created by jjheaney on 3/14/2022.
 */

public with sharing class ScholarshipSharedUtilities {

    public static PageReference setSid(PageReference pageRef, Boolean redir, String scholarshipId) {
        if (!String.isEmpty(scholarshipId)) {
            pageRef.getParameters().put('sid', scholarshipId);
        }
        pageRef.setRedirect(redir);
        return pageRef;
    }

    public static Scholarship__c getScholarshipInfo(String scholarshipId) {
        Scholarship__c scholarshipInfo = null;
        List<Scholarship__c> ScholarshipInfos = [
                SELECT Close_Date__c,Completion_Statement__c,Criteria_Statement__c,Description__c,Essay_1_Text__c,Essay_2_Text__c,
                        Id,Name,Open_Date__c,OwnerId,Question_1_Text__c,Question_2_Text__c,Question_3_Text__c,Question_4_Text__c,
                        Recommender2_Auto_Send__c,Recommender2_Description__c,Recommender2_Question__c,Recommender2__c,Recommender_Auto_Send__c,
                        Recommender_Description__c,Recommender_Question__c,Recommender__c,Scholarship_ID__c,Short_Description__c,
                        Review_Award_Process_Description__c,Self_Report_ACT_GPA_Criteria__c, Essay_1_Allow_Upload__c, Essay_2_Allow_Upload__c
                FROM Scholarship__c
                WHERE Scholarship_ID__c = :scholarshipId
        ];
        if (ScholarshipInfos.size() > 0) {
            scholarshipInfo = ScholarshipInfos[0];
        }

        return scholarshipInfo;
    }

    public static boolean isScholarshipOpen(Scholarship__c scholarship) {
        boolean scholarshipOpen;
        if (scholarship.Open_Date__c <= adjustForCentralTime(Datetime.now()) && scholarship.Close_Date__c >= adjustForCentralTime(Datetime.now())) {
            scholarshipOpen = true;
        } else {
            scholarshipOpen = false;
        }
        return scholarshipOpen;
    }

    public static String setHistoryPage(String scholarshipId) {
        String cPage = ApexPages.currentPage().getUrl();
        String[] cPageSplit = cPage.split('\\?');
        String historyURL = '/applicantportal/ScholarshipHome';
        if (cPageSplit.size() > 0) {
            historyURL = cPageSplit[0];
        }
        historyURL = historyURL.replace('/apex/', '/applicantportal/');
        if (!String.isEmpty(scholarshipId)) {
            historyURL += '?sid=' + scholarshipId;
        }
        return historyURL;
    }

    public static DateTime adjustForCentralTime(Datetime dt) {
        //Get the current GMT time and adjust for our timezone
        TimeZone tz = TimeZone.getTimeZone('America/Chicago');
        dt = dt.addSeconds(tz.getOffset(dt) / 1000);
        return dt;
    }
}