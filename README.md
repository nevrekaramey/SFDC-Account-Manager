# SFDC-Account-Manager
Page and Classes below should be added to local org where you would like to view the accounts from remote org
- AccountManager.page
- AccountList.cls	
- AccountManager.cls
- ConnectorClass.cls

Custom setting AccountManagerProperties has been added to local org which could be used to dynamically set the page size.

Rest Class below should be added to remote org to process incoming request
- callAccount.cls

To access the page in local org use Account Manager custom link from the Navigate home page component.

To access the page directly as a guest user follow the link below:

https://worldofrookie-developer-edition.na30.force.com/AccountManager

