@isTest(seealldata=true)
public class test_PricebookEntryUpdater {
    
    public static testmethod void test_CSVUpload(){
        
        string pbId = [select Id from Pricebook2 where isActive = true and isStandard = false limit 1].Id;
        
        string fileString = 'Pricebook Id,Item Number,Unit Price\n'
            + '00447/100,10\n'
            + 'ABCDE,232\n'
            + '3000052EZ,51\n';
        
        blob fileBlob = blob.valueOf(fileString);
        
        //PricebookEntryUpdater updater = new PricebookEntryUpdater();
        PricebookEntryUpdater.fileblob = fileBlob;
        PricebookEntryUpdater.getPricebookOptions();
        PricebookEntryUpdater.pricebookId = pbId;
        PricebookEntryUpdater.updatePricebookEntries();
    }

}