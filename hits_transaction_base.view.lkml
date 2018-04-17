view: hits_transaction_base {
    extension: required

    dimension: id {
      primary_key: yes
      sql: ${hits.id} ;;
    }
    dimension: transactionShipping {
      label: "Transaction Shipping"
    }

    dimension: affiliation {}

    dimension: curencyCode {
      label: "Curency Code"
    }

    dimension: localTransactionRevenue {
      label: "Local Transaction Revenue"
    }

    dimension: localTransactionTax {
      label: "Local Transaction Tax"
    }

    dimension: localTransactionShipping {
      label: "Local Transaction Shipping"
    }
}
