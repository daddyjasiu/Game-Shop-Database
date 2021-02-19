exec AddCustomer 'abcd1234','Kur', 'Bankiwa', 'kur.bankiwa@gmail.com', '569345333'
select * from Customers A, CustomerContacts B where A.Login = B.Login

insert into Positions
values (1,'szef totalny',20000)
exec AddEmployee 'Xorest', 'Mo¿ejko', 'xorest.mozejko@o2.pl', 'szef totalny','123654738' 
select * from Employees A, EmployeesContacts B where A.EmployeeId = B.EmployeeId

insert into ProductCategory
values (1, 'FPS')
insert into PEGIRating
values (1, '18')
insert into Publishers
values (1, 'Activision')
exec AddItem 'Quake 3', 'FPS', '1999 multiplayer-focused first-person shooter developed by id Software', '18','Activision', 15.00
select * from Items A, Products B where A.ItemId = B.ProductId

insert into Warehouses
values (1, 'Sakura', 'Japonia', 'Kyoto', 'Shichijo-dori 113', '+81 75 353 4126')
exec AddItemsToWarehouse 'Sakura', 'Quake 3', 10
select * from Warehouses A, ItemsInWarehouse B where A.WarehouseId= B.WarehouseId

insert into ProductCategory
values (2, 'Premium time')
insert into Publishers
values (2, 'Discord')
exec AddService 'Discord Nitro', 'Discord premium time', 31, 'Premium time', 'Discord', 10.00
select * from Products A, Services B where A.ProductId=B.ServiceId

select * from EmployeeSince(2021-02-19)

select * from MostExpensiveInCategory('Premium time')
select * from MostExpensiveInCategory('FPS')

select * from WarehouseItems('Quake 3')

print dbo.EmployeeOnPosition('szef totalny')

insert into Orders
values (1,default,'Kyoto','Japonia','Shichijo-dori 112',1)
insert into OrderDetails
values (1, 3, 15.00, 5, 0)
print dbo.DateIncome('2021-02-19')
select * from Orders A, OrderDetails B where A.OrderId=B.OrderID