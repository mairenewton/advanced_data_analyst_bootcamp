# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

view: Practice_NDT {
  derived_table: {
    explore_source: order_items {
      column: order_id { field: order_items.order_id }
      column: order_item_count {}
      column: total_revenue {}
      derived_column: rev_rank {
        sql: rank() over(order by total_revenue) ;;
      }
    }
  }
  dimension: order_id {
    type: number
    primary_key: yes
  }
  dimension: order_item_count {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  measure: avg_items {
    type:  average
    sql:  ${TABLE}.order_item_count ;;
  }

  measure: avg_rev {
    type:  average
    sql:  ${TABLE}.total_revenue ;;
  }

  dimension: rev_rank {
    type: number
  }

}
