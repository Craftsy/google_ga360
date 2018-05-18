view: hits_item_base {
    extension: required

    dimension: id {
      primary_key: yes
      sql: ${hits.id} ;;
    }

    dimension: transactionId {
      label: "Transaction ID"
    }

    dimension: productName {
      label: "Product Name"
    }

    dimension: productCategory {
      label: "Product Catetory"
    }

    dimension: productSku {
      label: "Product Sku"
    }

    dimension: itemQuantity {
      label: "Item Quantity"
    }

    dimension: itemRevenue {
      label: "Item Revenue"
    }

    dimension: curencyCode {
      label: "Curency Code"
    }

    dimension: localItemRevenue {
      label:"Local Item Revenue"
    }

    measure: total_item_revenue {
      type: sum
      sql: ${itemRevenue} ;;
    }

    measure: product_count {
      type: count_distinct
      sql: ${productSku} ;;
      drill_fields: [productName, productCategory, productSku, total_item_revenue]
    }
}
