public class ProductDAO {
	public static List<Product2> getProducts(Set<Id> productIds){
		return [
	        SELECT
	            Id,
	            Product_Stock_Name_1__c,
	            Product_Stock_Name_2__c,
	            Product_Stock_Name_3__c,
	            (SELECT id, Name, SVMXC__Location__r.Movex_Site_Id__c, SVMXC__Quantity2__c FROM SVMXC__Product_Stock__r Where SVMXC__Quantity2__c > 0 AND SVMXC__Location__r.Movex_Site_Id__c != null) 
	        FROM
	            Product2
	        WHERE
	            Id 
	        IN 
	            :productIds];
	}
}