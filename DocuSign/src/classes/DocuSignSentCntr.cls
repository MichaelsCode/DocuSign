public class DocuSignSentCntr {
    
    public PageReference sendDoc(){
        Blob SignDocument= Blob.valueOf(' '); 
        PageReference pr = new PageReference('/apex/DocuSignDynamicGeneration') ;
        SignDocument = pr.getContentAsPDF();
        DocuSignCredentials__c DocSignCredentials = DocuSignCredentials__c.getAll().values();
        String accountId        = DocSignCredentials.AccountId__c;
        String userId           = DocSignCredentials.UserId__c;
        String password         = DocSignCredentials.Password__c;
        String integratorsKey   = DocSignCredentials.IntegratorsKey__c;
        String webServiceUrl    = DocSignCredentials.WebServiceUrl__c;
        
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = webServiceUrl;
        dsApiSend.timeout_x=120000;
        
        String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password><IntegratorKey>' + integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';
        
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication',auth);
        
        
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject    = 'DocuSign from Raj'; 
        envelope.EmailBlurb = 'Review review the documnet and sign ';
        envelope.AccountId  = accountId;
        
        DocuSignAPI.Document document = new DocuSignAPI.Document();
        document.ID                     = 1;
        document.pdfBytes               = EncodingUtil.base64Encode(SignDocument);
        document.Name                   = 'Contract infomration';
        document.FileExtension          = '.pdf';
        envelope.Documents              = new DocuSignAPI.ArrayOfDocument();
        envelope.Documents.Document     = new DocuSignAPI.Document[1];
        envelope.Documents.Document[0]  = document;
        
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID            = 1;
        recipient.Type_x        = 'Signer';
        recipient.RoutingOrder  = 1;
        recipient.Email         = 'rajamohanvakati@gmail.com';
        recipient.UserName      = 'rajmoahn vakati';
        recipient.SignerName    = 'Rajamohan Vakati';
        
        DocuSignAPI.Recipient recipient1 = new DocuSignAPI.Recipient();
        recipient1.ID = 2;
        recipient1.Type_x = 'CarbonCopy';
        recipient1.RoutingOrder = 1;
        recipient1.UserName = 'mohan'; 
        recipient1.Email =  'tomohan.v@gmail.com'; 
        
        DocuSignAPI.Recipient recipient2 = new DocuSignAPI.Recipient();
        recipient2.ID = 3;
        recipient2.Type_x = 'CarbonCopy';
        recipient2.RoutingOrder = 1;
        recipient2.UserName = 'Raj '; 
        recipient2.Email =  'rajamohanvakati@outloo.com'; 
        
        
        
        envelope.Recipients                 = new DocuSignAPI.ArrayOfRecipient();
        envelope.Recipients.Recipient       = new DocuSignAPI.Recipient[3];
        envelope.Recipients.Recipient[0]    = recipient;
        envelope.Recipients.Recipient[1]    = recipient1;
        envelope.Recipients.Recipient[2]    = recipient2;
        
        DocuSignAPI.Tab tab1                = new DocuSignAPI.Tab();
        tab1.Type_x                         = 'SignHere';
        tab1.RecipientID                    = 1;
        tab1.DocumentID                     = 1;
        tab1.AnchorTabItem                  = new DocuSignAPI.AnchorTab();
        tab1.AnchorTabItem.AnchorTabString  = 'Signaturetag';
        
        DocuSignAPI.Tab tab2                = new DocuSignAPI.Tab();
        tab2.Type_x                         = 'DateSigned';
        tab2.RecipientID                    = 1;
        tab2.DocumentID                     = 1;
        tab2.AnchorTabItem                  = new DocuSignAPI.AnchorTab();
        tab2.AnchorTabItem.AnchorTabString  = 'signdatetag';
        
        DocuSignAPI.Tab tab4                = new DocuSignAPI.Tab();
        tab4.Type_x                         = 'FullName';
        tab4.RecipientID                    = 1;
        tab4.DocumentID                     = 1;
        tab4.AnchorTabItem                  = new DocuSignAPI.AnchorTab();
        tab4.AnchorTabItem.AnchorTabString  = 'cstnamtag';
        
        
        envelope.Tabs                       = new DocuSignAPI.ArrayOfTab();
        envelope.Tabs.Tab                   = new DocuSignAPI.Tab[5];
        envelope.Tabs.Tab[0]                = tab1;        
        envelope.Tabs.Tab[1]                = tab2;       
        envelope.Tabs.Tab[3]                = tab4;       
        
        
        DocuSignAPI.EnvelopeStatus EnvStatus = dsApiSend.CreateAndSendEnvelope(envelope);
        String envelopeId = EnvStatus.EnvelopeID;
        
        dsfs__DocuSign_Status__c DocStatus      = new dsfs__DocuSign_Status__c();
        DocStatus.dsfs__DocuSign_Envelope_ID__c = envelopeId;
        DocStatus.dsfs__Sender__c               = userinfo.getusername();
        DocStatus.dsfs__Sender_Email__c         = userinfo.getuseremail();
        DocStatus.dsfs__Subject__c              = envelope.Subject;
        DocStatus.dsfs__Envelope_Status__c  = EnvStatus.status;
        insert DocStatus;
        
        return null ;
    }
    
}