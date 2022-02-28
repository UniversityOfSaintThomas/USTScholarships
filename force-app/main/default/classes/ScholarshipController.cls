public class ScholarshipController {
    public String scholarshipId { get; set; }

    public Scholarship__c ScholarshipInfo { get; set; }
    public Scholarship_Applicant__c ScholarshipApplicant { get; set; }
    public String Essay1Filename { get; set; }
    public String Essay2Filename { get; set; }
    public Boolean e1Text { get; set; }
    public Boolean e2Text { get; set; }
    public Attachment Essay1 { get {if (Essay1 == null) Essay1 = new Attachment(); return Essay1;} set; }
    public Attachment Essay2 { get {if (Essay2 == null) Essay2 = new Attachment(); return Essay2;} set; }
    public String pageURL { get; set; }
    public Boolean scholarshipClosed { get; set; }
    public Boolean scholarshipOpen { get; set; }
    public Id activeApplicationID { get; set; }
    public Datetime startedDateSet { get; set; }
    public Datetime recommendRequestDate1 {get;set;}
    public Datetime recommendRequestDate2 {get;set;}


    public ScholarshipController() {
//        scholarshipClosed = false;
//        scholarshipOpen = false;
    }

    public List<Scholarship__c> getAvailableScholarships() {
        ScholarshipInfo = new Scholarship__c();
        List<Scholarship__c> availableScholarships = [
                SELECT Name,Id,Scholarship_ID__c,Short_Description__c
                FROM Scholarship__c
                WHERE Open_Date__c <= TODAY AND Close_Date__c >= TODAY
                ORDER BY Name ASC NULLS FIRST
        ];
        return availableScholarships;
    }

    public PageReference chooseScholarship() {
        //action sets scholarshipId
        getScholarshipInfo();
        if (ScholarshipInfo == null) {
            return null;
        }
        getApplicantInfo();
        setHistoryPage();
        return setSid(Page.ScholarshipApplication, false);
    }

    public void getScholarshipInfo() {
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
            ScholarshipInfo = ScholarshipInfos[0];
        }
        if (ScholarshipInfo.Open_Date__c <= adjustForCentralTime(Datetime.now()) && ScholarshipInfo.Close_Date__c >= adjustForCentralTime(Datetime.now())) {
            scholarshipOpen = true;
        } else {
            scholarshipOpen = false;
        }
    }

    public void getApplicantInfo() {
       /* if (ScholarshipInfo != null) {
            List<Scholarship_Applicant__c> ScholarshipApplicants = [
                    SELECT Applicant_Email__c,Applicant_First_Name__c,Applicant_Last_Name__c,Application__c,Confirmed_Criteria__c,
                            Declared_ACT_SAT__c,Declared_GPA__c,Essay_1_Answer__c,Essay_1_Uploaded__c,Essay_2_Answer__c,
                            Essay_2_Uploaded__c,Id,Name,Question_1_Answer__c,Question_2_Answer__c,Question_3_Answer__c,
                            Question_4_Answer__c,Recommendation2__c,Recommendation__c,Recommender2_Email__c,Recommender2_Name__c,
                            Recommender_Email__c,Recommender_Name__c,Scholarship_Complete__c,Scholarship__c,Signature__c, Scholarship_Status__c,
                            Essay_1_Uploaded_Orig_Filename__c, Essay_2_Uploaded_Orig_Filename__c, Scholarship_Date_Started__c, Scholarship_Date_Submitted__c,
                            Recommendation2_Request_Date__c, Recommendation_Request_Date__c
                    FROM Scholarship_Applicant__c
                    WHERE Application__c = :activeApplicationID
                    AND Scholarship__c = :ScholarshipInfo.Id
            ];


            if (ScholarshipApplicants.size() > 0) {
                //load in scholarship applicant
                ScholarshipApplicant = ScholarshipApplicants[0];
                e1Text = !String.isEmpty(ScholarshipApplicant.Essay_1_Answer__c);
                e2Text = !String.isEmpty(ScholarshipApplicant.Essay_2_Answer__c);
                If (ScholarshipApplicant.Recommendation2_Request_Date__c != null) {
                    recommendRequestDate2 = adjustForCentralTime(ScholarshipApplicant.Recommendation2_Request_Date__c);
                }

                If (ScholarshipApplicant.Recommendation_Request_Date__c != null) {
                    recommendRequestDate1 = adjustForCentralTime(ScholarshipApplicant.Recommendation_Request_Date__c);
                }
            } else {
                //Create a new schloarship applicant if there is none already
                ScholarshipApplicant = new Scholarship_Applicant__c();
                e1Text = false;
                e2Text = false;

            }
        }*/
    }

    public PageReference SaveCriteria() {
        //Validate input
        /*if (String.isEmpty(ScholarshipApplicant.Application__c)) {
            ScholarshipApplicant.Application__c = ActiveApplicationId;
        }
        ScholarshipApplicant.Scholarship__c = ScholarshipInfo.Id;
        ScholarshipApplicant.Scholarship_Status__c = 'Started App';

        if (ScholarshipApplicant.Scholarship_Date_Started__c == null) {
            ScholarshipApplicant.Scholarship_Date_Started__c = Datetime.now();
        }

        try {
            upsert ScholarshipApplicant;
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
        }
        getApplicantInfo();
        pageURL = ApexPages.currentPage().getUrl();
        setHistoryPage();
        return setSid(Page.ScholarshipApplication2, false);*/
        return null;
    }

    public PageReference SaveApplication() {
        try {
            upsert ScholarshipApplicant;
            e1Text = !String.isEmpty(ScholarshipApplicant.Essay_1_Answer__c);
            e2Text = !String.isEmpty(ScholarshipApplicant.Essay_2_Answer__c);
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
        }
        setHistoryPage();
        return null;
    }

    public void SaveFinishLater() {
/*        try {
            upsert ScholarshipApplicant;
            e1Text = !String.isEmpty(ScholarshipApplicant.Essay_1_Answer__c);
            e2Text = !String.isEmpty(ScholarshipApplicant.Essay_2_Answer__c);
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
        }
        String msgComplete = 'Your scholarship application has been saved and you can return to it at any time.';
        msgComplete += ' It has not been completed and will not be considered for an award until you complete it by clicking \"Save & Complete\" below.';

        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, msgComplete));*/
    }
    public PageReference SaveComplete() {
/*        try {
            ScholarshipApplicant.Scholarship_Complete__c = true;
            ScholarshipApplicant.Scholarship_Status__c = 'Submitted App';
            ScholarshipApplicant.Scholarship_Date_Submitted__c = Datetime.now();
            upsert ScholarshipApplicant;
            sendRecommenderEmail();
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
        } finally {
            String styledP = '<p style="margin: 10px 0;padding: 0;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: rgb(85, 85, 85);font-family: Palatino Linotype, Georgia, serif;font-size: 16px;line-height: 150%;text-align: left;">';
            String cMessage = '<h2>Your scholarship application has been received!</h2>';
            cMessage += styledP + ActiveApplication.EnrollmentrxRx__Applicant_First_Name__c + ' ' + ActiveApplication.EnrollmentrxRx__Applicant_Last_Name__c + ',</p>';
            cMessage += styledP + 'Your application to the ' + ScholarshipInfo.Name + ' has been received.</p>';
            if (ScholarshipInfo.Description__c != null) {
                cMessage += styledP + '<strong>Scholarship Description</strong><br/>' + ScholarshipInfo.Description__c + '</p>';
            }
            if (ScholarshipInfo.Review_Award_Process_Description__c != null) {
                cMessage += styledP + '<strong>What happens next?</strong><br/>' + ScholarshipInfo.Review_Award_Process_Description__c + '</p>';
            }
            sendEmail(ActiveApplication.EnrollmentrxRx__Applicant_First_Name__c + ' ' + ActiveApplication.EnrollmentrxRx__Applicant_Last_Name__c, ActiveApplication.EnrollmentrxRx__Email_Address__c, 'University of St. Thomas Scholarship', cMessage, cMessage);
        }
        setHistoryPage();
        return setSid(Page.ScholarshipApplicationComplete, false);*/
        return null;
    }

    public PageReference GoHome() {
        setHistoryPage();
        return Page.ScholarshipHome.setRedirect(true);
    }

    public PageReference GoCriteria() {
/*        setHistoryPage();
        return setSid(Page.ScholarshipApplication, false);*/
        return null;
    }

    public void completedPage() {
/*        String sId = ApexPages.currentPage().getParameters().get('sid');
        if (!String.isBlank(sId)) {
            scholarshipId = sId;
            ActiveApplicationId = PortalUtility.getActiveApplicationId();
            getScholarshipInfo();
            getApplicantInfo();
        }*/
    }

    public PageReference sanityCheck() {
/*
        String sId = ApexPages.currentPage().getParameters().get('sid');
        if (!String.isBlank(sId)) {
            scholarshipId = sId;
            ActiveApplicationId = PortalUtility.getActiveApplicationId();
            getScholarshipInfo();
            getApplicantInfo();
        }
        if (String.isEmpty(scholarshipId)) {
            return Page.ScholarshipHome.setRedirect(true);
        }

        if (ScholarshipInfo == null) {
            return Page.ScholarshipHome.setRedirect(true);
        }

        if (ScholarshipApplicant.Scholarship_Complete__c) {
            return new PageReference('/applicantportal/ScholarshipApplicationComplete?sid=' + scholarshipId);
            //return setSid(Page.ScholarshipApplicationComplete, false);
        }
        if (!scholarshipOpen || scholarshipClosed) {
            return setSid(Page.ScholarshipClosed, false);
        }
*/

        return null;
    }

    public PageReference setSid(PageReference pageRef, Boolean redir) {
        if (!String.isEmpty(ScholarshipId)) {
            pageRef.getParameters().put('sid', scholarshipId);
        }
        pageRef.setRedirect(redir);
        return pageRef;
    }

    public PageReference UploadEssay1() {

        String ext = getFileExtension(Essay1Filename);
        Essay1.OwnerId = UserInfo.getUserId();
        Essay1.ParentId = ScholarshipApplicant.Id; // the record the file is attached to
        Essay1.IsPrivate = false;
        Essay1.name = 'Essay1' + ext;
        Essay1.Description = 'Essay One Upload. Original Filename was ' + Essay1Filename;

        try {
            insert Essay1;
            ScholarshipApplicant.Essay_1_Uploaded__c = true;
            ScholarshipApplicant.Essay_1_Uploaded_Orig_Filename__c = Essay1Filename;
            upsert ScholarshipApplicant;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading essay attachment'));
            return null;
        } finally {
            Essay1 = new Attachment();
        }

        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Essay attachment uploaded successfully'));
        return null;
    }

    public void DeleteEssay1() {
      /*  List<Attachment> att1 = [select id, name from Attachment where parent.id = :ScholarshipApplicant.id AND name LIKE 'Essay1.%'];
        try {
            for (Attachment att : att1) {
                delete att;
            }
            ScholarshipApplicant.Essay_1_Uploaded__c = false;
            upsert ScholarshipApplicant;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No attachment to delete'));
        }*/
    }

    public PageReference UploadEssay2() {

        String ext = getFileExtension(Essay2Filename);
        Essay2.OwnerId = UserInfo.getUserId();
        Essay2.ParentId = ScholarshipApplicant.Id; // the record the file is attached to
        Essay2.IsPrivate = false;
        Essay2.name = 'Essay2' + ext;
        Essay2.Description = 'Essay One Upload. Original Filename was ' + Essay2Filename;

        try {
            insert Essay2;
            ScholarshipApplicant.Essay_2_Uploaded__c = true;
            ScholarshipApplicant.Essay_2_Uploaded_Orig_Filename__c = Essay2Filename;
            upsert ScholarshipApplicant;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading essay attachment'));
            return null;
        } finally {
            Essay2 = new Attachment();
        }

        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Essay attachment uploaded successfully'));
        return null;
    }

    public void DeleteEssay2() {
      /*  List<Attachment> att1 = [select id, name from Attachment where parent.id = :ScholarshipApplicant.id AND name LIKE 'Essay2.%'];
        try {
            for (Attachment att : att1) {
                delete att;
            }
            ScholarshipApplicant.Essay_2_Uploaded__c = false;
            upsert ScholarshipApplicant;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No attachment to delete'));
        }*/
    }

    public string getFileExtension(String fn) {
        if (fn.contains('.')) {
            fn = fn.substring(fn.lastIndexOf('.'), fn.length());
            return fn;
        }
        return '';
    }


    public void sendRecommenderEmail() {
        String RecEmail = '';
        String RecName = '';
        String RecLink = '';
        String RecMessage = '';
        String RecSubject = 'University of St. Thomas ' + ScholarshipInfo.Name;
        String styledP = '<p style="margin: 10px 0;padding: 0;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: rgb(85, 85, 85);font-family: Palatino Linotype, Georgia, serif;font-size: 16px;line-height: 150%;text-align: left;">';
        for (Integer xx = 1; xx < 3; xx++) {
            RecEmail = '';
            RecName = '';
            RecLink = Site.getBaseSecureUrl() + '/ScholarshipRecommender';
            recMessage = styledP + UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' has applied for the ' + ScholarshipInfo.Name + ' at the University of St. Thomas and indicated that you would be willing to write a recommendation. </p>';
            if (ScholarshipInfo.Description__c != null) {
                recMessage += styledP + '<strong>Scholarship Description</strong><br/>' + ScholarshipInfo.Description__c + '</p>';
            }

            if (xx == 1
                    && ScholarshipInfo.Recommender_Auto_Send__c
                    && String.isNotBlank(ScholarshipApplicant.Recommender_Email__c)
                    && String.isNotBlank(ScholarshipApplicant.Recommender_Name__c)
                    && ScholarshipApplicant.Recommendation_Request_Date__c == null
                    ) {

                RecEmail = ScholarshipApplicant.Recommender_Email__c;
                RecName = ScholarshipApplicant.Recommender_Name__c;
                RecLink += '?recid=' + ScholarshipApplicant.Id + '1';
                if (ScholarshipInfo.Recommender_Question__c != null) {
                    recMessage += styledP + ScholarshipInfo.Recommender_Question__c + '</p>';
                }
                recMessage += styledP + '<a href="' + RecLink + '" class="button">Submit your recommendation</a></p>';
            }
            if (xx == 2
                    && ScholarshipInfo.Recommender2_Auto_Send__c
                    && String.isNotBlank(ScholarshipApplicant.Recommender2_Email__c)
                    && String.isNotBlank(ScholarshipApplicant.Recommender2_Name__c)
                    && ScholarshipApplicant.Recommendation2_Request_Date__c == null
                    ) {
                RecEmail = ScholarshipApplicant.Recommender2_Email__c;
                RecName = ScholarshipApplicant.Recommender2_Name__c;
                RecLink += '?recid=' + ScholarshipApplicant.Id + '2';
                if (ScholarshipInfo.Recommender2_Question__c != null) {
                    recMessage += styledP + ScholarshipInfo.Recommender2_Question__c + '</p>';
                }
                recMessage += styledP + '<a href="' + RecLink + '" class="button">Submit your recommendation</a></p>';
            }


            if (!String.isEmpty(RecEmail)) {
                sendEmail(RecName, RecEmail, RecSubject, RecMessage, RecMessage);
                if (String.isNotBlank(ScholarshipApplicant.Recommender_Name__c) && String.isNotBlank(ScholarshipApplicant.Recommender_Email__c)) {
                    ScholarshipApplicant.Recommendation_Request_Date__c = Datetime.now();
                    recommendRequestDate1 = adjustForCentralTime(Datetime.now());
                }
                if (String.isNotBlank(ScholarshipApplicant.Recommender2_Name__c) && String.isNotBlank(ScholarshipApplicant.Recommender2_Email__c)) {
                    ScholarshipApplicant.Recommendation2_Request_Date__c = Datetime.now();
                    recommendRequestDate2 = adjustForCentralTime(Datetime.now());
                }
                upsert ScholarshipApplicant;
            }
        }
    }

    public void sendEmail(String Name, String EmailAddress, String Subject, String HTMLBodyText, String PlainBodyText) {
/*        if (!String.isEmpty(EmailAddress)) {
            // grab the email template
            EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name = '2017 Scholarship Email Template' LIMIT 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'admissions@stthomas.edu'];

            String templateSubject = EmailTemplate.Subject;
            templateSubject = templateSubject.replace('{!ScholarshipEmailSubject}', ScholarshipInfo.Name);

            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ScholarshipEmailBody}', HTMLBodyText);

            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ScholarshipEmailBody}', PlainBodyText);

            // Now create a new single email message object
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(new String[]{
                    EmailAddress
            });
            // mail.setCcAddresses(ccAddresses);

            // Specify the address used when the recipients reply to the email.
            // mail.setTemplateId('00X30000001GLJj');
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setSubject(Subject);
            mail.setBccSender(false);

// Optionally append the salesforce.com email signature to the email.
// The email address of the user executing the Apex Code will be used.
            mail.setUseSignature(false);

// Specify the text content of the email.
            mail.setPlainTextBody(plainBody);
            mail.setHtmlBody(htmlBody);

// Send the email you have created.
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                    mail
            });
        }*/
    }
    public void setHistoryPage() {
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
        pageURL = historyURL;
    }

    public DateTime adjustForCentralTime(Datetime dt) {
        //Get the current GMT time and adjust for our timezone
        //tz = TimeZone.getTimeZone('America/Chicago');
        //Timezone adjustment example below:
        //Datetime NowDate = Datetime.now();
        //NowDate = NowDate.addSeconds(tz.getOffset(NowDate)/1000);
        TimeZone tz = TimeZone.getTimeZone('America/Chicago');
        dt = dt.addSeconds(tz.getOffset(dt) / 1000);
        return dt;
    }


}