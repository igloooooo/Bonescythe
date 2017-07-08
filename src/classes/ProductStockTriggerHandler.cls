public class ProductStockTriggerHandler {
	public static void trunkProduct(List< SVMXC__Product_Stock__c > productstocks, Map<Id, SVMXC__Product_Stock__c > oldProductstocks){
    
	    Set<Id> productIds = new Set <Id>();
	    
	    for (SVMXC__Product_Stock__c productStock : productstocks) {
	    	if((oldProductstocks != null && oldProductstocks.containsKey(productStock.Id) && oldProductstocks.get(productStock.Id).SVMXC__Quantity2__c != productStock.SVMXC__Quantity2__c && (productStock.SVMXC__Quantity2__c == 0 || oldProductstocks.get(productStock.Id).SVMXC__Quantity2__c == 0) ) 
	    		|| (oldProductstocks == null && productStock.SVMXC__Quantity2__c > 0)){
	    		productIds.add(productStock.SVMXC__Product__c);
	    	}
	    }

	    List<Product2> productList = ProductDAO.getProducts(productIds);
	    
	    
	    for(Product2 product: productList){
	    	String productStockName = '';
	    	for(SVMXC__Product_Stock__c stock: product.SVMXC__Product_Stock__r){
	    		productStockName += (stock.SVMXC__Location__r.Movex_Site_Id__c.substring(3, stock.SVMXC__Location__r.Movex_Site_Id__c.length()))+',';
	    	}
	    	if(productStockName.length() > 255){
	    		product.Product_Stock_Name_1__c = productStockName.substring(0, 254);
	    		productStockName = productStockName.substring(255, productStockName.length());
	    		if(productStockName.length() > 255){
		    		product.Product_Stock_Name_2__c = productStockName.substring(0, 254);
		    		productStockName = productStockName.substring(255, productStockName.length());
		    	}else{
		    		product.Product_Stock_Name_2__c = productStockName;
		    		if(productStockName.length() > 255){
			    		product.Product_Stock_Name_3__c = productStockName.substring(0, 254);
			    		productStockName = productStockName.substring(255, productStockName.length());
			    	}else{
			    		product.Product_Stock_Name_3__c = productStockName;
			    	}
		    	}
		    }else{
	    		product.Product_Stock_Name_1__c = productStockName;
	    	}
	    	
	    }

	    if(productList.size() > 0){
	    	update productList;
	    }
	}
}