# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

view: profit_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: total_profit {field: order_items.total_profit}
      column: created_month {field: order_items.created_month}
      column: order_item_count {field: order_items.order_item_count}
      derived_column: total_profit_per_item {
        sql: total_profit/order_item_count ;;
      }
    }
  }
  dimension: total_profit {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: created_month {
    primary_key: yes
    description: "When the order was created"
    type: date_month
  }
  dimension: order_item_count {
    type: number
  }

  dimension: total_profit_per_item {
    type:  number
    sql: total_profit_per_item ;;
  }
}
