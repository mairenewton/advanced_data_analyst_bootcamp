view: order_fact_ndt {
   derived_table: {
    distribution: "order_id"
    sortkeys: ["order_id"]
    datagroup_trigger: order_items_trigger
      explore_source: order_items {
        column: id { field: users.id }
        column: order_id {}
        column: total_revenue {}
        column: order_item_count {}
        derived_column: revenue_rank {
          sql: rank() over (partition by id order by total_revenue desc) ;;
        }
      }
    }


    dimension: id {
      type: number
    }
    dimension: order_id {
      primary_key: yes
      type: number
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: order_item_count {
      type: number
    }

    dimension: revenue_rank {
      type: number

    }

}
