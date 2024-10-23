#! /bin/bash
PSQL='psql -X -U freecodecamp -d salon -t -c'

MAIN_MENU(){
echo -e '\nPlease choose a service\n'
SERVICES=$($PSQL "SELECT * FROM services")
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
echo "$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED
SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_ID ]]
then
MAIN_MENU
else echo -e '\nEnter your phone number.\n'
#get service name
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")
#get customer phone number
read CUSTOMER_PHONE
#try get customer name from phone
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
#if not exist
if [[ -z $CUSTOMER_NAME ]]
then
echo -e '\nPlease enter your name\n'
read CUSTOMER_NAME
#insert new customer
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi
#get appointment time from user
echo -e '\nWhat time would you like your appointment?\n'
read SERVICE_TIME
#get customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#update appointment table
INSERT_APP_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

fi
}
MAIN_MENU