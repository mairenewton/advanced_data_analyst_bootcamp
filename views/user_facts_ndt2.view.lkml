# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_facts_ndt2 {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: total_revenue {field: order_items.total_revenue}
      column: order_count {field: order_items.order_item_count}
      derived_column: order_revenue_rank {
        sql:  rank() over(order by total_revenue desc) ;;
      }
    }
  }
  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
    sql: ${TABLE}.total_revenue ;;
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: order_revenue_rank {
    type: number
    sql:  ${TABLE}.order_revenue_rank ;;
  }
}
