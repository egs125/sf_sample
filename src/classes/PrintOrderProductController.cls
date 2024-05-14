public with sharing class PrintOrderProductController {
    public List<OrderItem> listOrderItem { get; set; }
    public PrintOrderProductController() {
        Id recordId = ApexPages.currentPage().GetParameters().get('recordId');
        listOrderItem = new List<OrderItem>();
        listOrderItem = [
                SELECT Id, Product2.Name, OrderItemNumber, Quantity, UnitPrice
                FROM OrderItem
                WHERE OrderId = :recordId
        ];
    }
}