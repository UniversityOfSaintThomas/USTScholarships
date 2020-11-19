public class ScholarshipRecommenderController {

    public String recId { get; set; }
    public Integer recNum { get; set; }
    public Scholarship__c ScholarshipInfo { get; set; }
    public Scholarship_Applicant__c ScholarshipApplicant { get; set; }
    public boolean recComplete { get; set; }

    public ScholarshipRecommenderController() {

    }

    public PageReference buildRecommendation() {
        recId = ApexPages.currentPage().getParameters().get('recid');
        if (!String.isEmpty(recId)) {
            //get last number in recId to find if recommeder one or 2
            if (recId.substring(recId.length() - 1, recId.length()).isNumeric()) {
                recNum = Integer.valueof(recId.substring(recId.length() - 1, recId.length()));
                if (recNum < 0 || recNum > 2) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Could not determine recommender number.'));
                    return null;
                }
                //clean the last character off of the recid that identifies which number recommender
                recId = recId.substring(0, recId.length() - 1);

                if (recId.length() > 15) {
                    //get scholarship and applicant object opbject
                    Scholarship_Applicant__c[] sa = [SELECT Scholarship__c,Recommendation2__c,Recommendation__c,Recommender2_Email__c,Recommender2_Name__c,Recommender_Email__c,Recommender_Name__c, Recommendation_Received__c, Recommendation2_Received__c FROM Scholarship_Applicant__c WHERE ID = :recId];
                    if (sa.size() > 0) {
                        ScholarshipApplicant = sa[0];
                        if (recNum == 1) {
                            if (ScholarshipApplicant.Recommendation_Received__c != null) {
                                recComplete = true;
                            }
                        } else if (recNum == 2) {
                            if (ScholarshipApplicant.Recommendation2_Received__c != null) {
                                recComplete = true;
                            }
                        }
                    } else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Could not find scholarship applicant record.'));
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Could not find scholarship applicant record.'));
                }

                //get general scholarship information
                if (ScholarshipApplicant != null) {
                    Scholarship__c[] schol = [SELECT Description__c,Name,Recommender2_Question__c,Recommender_Question__c,Short_Description__c FROM Scholarship__c WHERE ID = :ScholarshipApplicant.Scholarship__c LIMIT 1];
                    if (schol.size() > 0) {
                        ScholarshipInfo = schol[0];
                    } else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Could not find scholarship information.'));
                    }
                }
            }

        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not determin recommender number.'));
        }
        return null;
    }

    public PageReference Save() {
        doCRUD CRUDToDo = new doCRUD();
        if (recNum == 1) {
            ScholarshipApplicant.Recommendation_Received__c = Datetime.now();
        } else if (recNum == 2) {
            ScholarshipApplicant.Recommendation2_Received__c = Datetime.now();
        }
        CRUDToDo.saveRecommendation(ScholarshipApplicant);
        recComplete = true;
        return null;
    }

    private without sharing class doCRUD {

        public void saveRecommendation(Scholarship_Applicant__c scholar) {
            try {
                upsert scholar;
            } catch (DmlException ex) {
                ApexPages.addMessages(ex);
            }
        }

    }

}