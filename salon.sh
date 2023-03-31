#! /bin/bash


PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# display available services
DISPLAY_SERVICES() {
  SERVICES_AVAILABLE=$($PSQL "SELECT * FROM services")
  echo -e "--- Services Available ---\n"
  echo "$SERVICES_AVAILABLE" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
}


SELECT_SERVICE() {
  # select service
  echo -e "\nPlease Select Service\n"
  read SERVICE_ID_SELECTED
  MENU_SELECTION=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  # if not available
  if [[ -z $MENU_SELECTION ]]
  then
    # return to select menu
    echo -e "Your selection is not available\n"
    DISPLAY_SERVICES
    SELECT_SERVICE
  fi
}

GET_CUSTOMER_INFO() {
  # get customer information
  echo "Please enter your phone number: "
  read CUSTOMER_PHONE
  # if not customer
  EXISTING_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $EXISTING_CUSTOMER ]]
  then
    # get customer name
    echo "Please enter your name: "
    read CUSTOMER_NAME
     # enter name and phone 
    ENTER_NAME_AND_PHONE=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  else
    CUSTOMER_NAME=$EXISTING_CUSTOMER
    echo 1 $CUSTOMER_NAME 1
  fi
    # get service time
    echo "Please enter appointment time: "
    read SERVICE_TIME  
}

ENTER_APPOINTMENT() {
  # enter customer appointment
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
}

DISPLAY_CONFIRMATION() {
  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  # display message
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

DISPLAY_SERVICES
SELECT_SERVICE
GET_CUSTOMER_INFO
ENTER_APPOINTMENT
DISPLAY_CONFIRMATION

exit
