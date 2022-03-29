@all
Feature: Service for transferring money from company to employee accounts

    # TEST_USER_1: "id"=1, "firstName="David", paymentsMethods: {id=1, "name"="My bank account"}, {id=2, "name"="My mom account"}, "maxWithdrawalAmount": 100.0, "maxWithdrawals": 4

      # Positive scenarios

  Scenario: 01 Successful response from the Service: number of withdrawals < maxWithdrawals, sum of withdrawals < maxWithdrawalAmount, executeAt = current time

    Given save the current time
    When Marty is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
    """
[
   {
         "amount":22,
         "executeAt":##currentDate##
      }
]
    """

    Then Marty receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'

    And the response message contains:
    """
[
    {
        "id": ##ID1##,
        "amount": 22.0,
        "executeAt": "##formattedCurrentDate##",
        "userId": 1,
        "paymentMethodId": 1,
        "status": "PENDING"
    }
]
     """

    And wait for 100 ms
    And the record with the status 'PENDING' and ID '##ID1##' is created in DB


  Scenario: 02 Successful response from the Service: number of withdrawals = maxWithdrawals, sum of withdrawals < maxWithdrawalAmount, executeAt = current time

    Given save the current time
    When Doc is doing a POST request by path '/v1/withdrawals/users/2/payment-methods/1' with parameters:
    """
[
   {
         "amount":10,
         "executeAt":##currentDate##
      },
       {
         "amount":10,
         "executeAt":##currentDate##
      }
]
    """

    Then Doc receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'
    And save ID № 2 from the response message in the variable '##ID2##'

    And the response message contains:
    """
[
    {
        "id": ##ID1##,
        "amount": 10.0,
        "executeAt": "##formattedCurrentDate##",
        "userId": 2,
        "paymentMethodId": 1,
        "status": "PENDING"
    },
      {
        "id": ##ID2##,
        "amount": 10.0,
        "executeAt": "##formattedCurrentDate##",
        "userId": 2,
        "paymentMethodId": 1,
        "status": "PENDING"
    }
]
     """

    And wait for 100 ms
    And the record with the status 'PENDING' and ID '##ID1##' is created in DB
    And the record with the status 'PENDING' and ID '##ID2##' is created in DB


  Scenario: 03 Successful response from the Service: number of withdrawals < maxWithdrawals, sum of withdrawals = maxWithdrawalAmount, executeAt = current time

    Given save the current time
    When Einstein is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
    """
[
   {
         "amount":100,
         "executeAt":##currentDate##
      }
]
    """

    Then Einstein receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'

    And the response message contains:
    """
[
    {
        "id": ##ID1##,
        "amount": 100.0,
        "executeAt": "##formattedCurrentDate##",
        "userId": 1,
        "paymentMethodId": 1,
        "status": "PENDING"
    }
]
     """

    And wait for 100 ms
    And the record with the status 'PENDING' and ID '##ID1##' is created in DB


  Scenario: 04 Checking of user's list receiving

    When Lorraine is doing a GET request by path '/v1/users'
    Then Lorraine receives the response with the code '200'
    And the response message contains:
    """
    [
    {
        "id": 1,
        "firstName": "David",
        "paymentMethods": [
            {
                "id": 1,
                "name": "My bank account"
            },
            {
                "id": 2,
                "name": "My mom account"
            }
        ],
        "maxWithdrawalAmount": 100.0,
        "maxWithdrawals": 4
     """


  Scenario: 05 Checking of the worker's processing

    Given save the current time
    When George is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
    """
[
   {
         "amount":22,
         "executeAt":##currentDate##
      }
]
    """

    Then George receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'

    And wait for 100 ms
    And the record with the status 'PENDING' and ID '##ID1##' is created in DB

    And wait for 5000 ms
    And the record with the status 'SUCCESS' and ID '##ID1##' is created in DB


  Scenario: 06 Successful response from the Service: executeAt = future time

    Given save the future time
    When Marty is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
    """
[
   {
         "amount":22,
         "executeAt":##currentDate+10sec##
      }
]
    """

    Then Marty receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'

    And wait for 6000 ms
    And the record with the status 'PENDING' and ID '##ID1##' is created in DB
    And wait for 7000 ms
    And the record with the status 'SUCCESS' and ID '##ID1##' is created in DB

    # Negative scenarios

  Scenario: 07 Error response from the Service: sum of withdrawals > maxWithdrawalAmount

    Given save the current time
    When Biff is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
    """
[
   {
         "amount":500,
         "executeAt":##currentDate##
      }
]
    """

    Then Biff receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'
    And the response message contains:
    """
        "status": "FAILED"
     """


  Scenario: 08 Error response from the Service: number of withdrawals > maxWithdrawals

    Given save the current time
    When Marvin is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
    """
[
   {
         "amount":5,
         "executeAt":##currentDate##
      },
      {
         "amount":5,
         "executeAt":##currentDate##
      },
      {
         "amount":5,
         "executeAt":##currentDate##
      },
      {
         "amount":5,
         "executeAt":##currentDate##
      },
      {
         "amount":5,
         "executeAt":##currentDate##
      }
]
    """

    Then Marvin receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'
    And the response message contains:
    """
        "status": "FAILED"
     """


  Scenario: 09 Error response from the Service: number of withdrawals > maxWithdrawals, sum of withdrawals > maxWithdrawalAmount

    Given save the current time
    When Jennifer is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
    """
[
   {
         "amount":5000,
         "executeAt":##currentDate##
      },
      {
         "amount":5000,
         "executeAt":##currentDate##
      },
      {
         "amount":5000,
         "executeAt":##currentDate##
      },
      {
         "amount":5000,
         "executeAt":##currentDate##
      },
      {
         "amount":5000,
         "executeAt":##currentDate##
      }
]
    """

    Then Jennifer receives the response with the code '200'
    And save ID № 1 from the response message in the variable '##ID1##'
    And the response message contains:
    """
        "status": "FAILED"
     """


#   #TODO: need to find out the expected result (not described in documentation)
#  Scenario: 10 Error response from the Service: attempt to pass a non-existent user

#    Given save the current time
#    When Jules is doing a POST request by path '/v1/withdrawals/users/99/payment-methods/1' with parameters:
#    """
#[
#   {
#         "amount":22,
#         "executeAt":##currentDate##
#      }
#]
#    """

#    Then Jules receives the response with the code '???'


#  #TODO: need to find out the expected result (not described in documentation)
#  Scenario: 11 Error response from the Service: attempt to pass a parameter executeAt < currentTime

#    # "executeAt":0 = "1970-01-01T00:00:00Z"
#    When Verne is doing a POST request by path '/v1/withdrawals/users/1/payment-methods/1' with parameters:
#    """
#[
#   {
#         "amount":22,
#         "executeAt":0
#      }
#]
#    """
#
#    Then Verne receives the response with the code '???'