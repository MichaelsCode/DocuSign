public with sharing class DocuSignDynamicGenerationController {
    public List<Contract> contaract {get;set;}
    public DocuSignDynamicGenerationController(){
        contaract = [Select Id , ContractNumber , StartDate ,EndDate , Name , Status , ActivatedById, ContractTerm  from  Contract Limit 20] ; 
    }
    
}