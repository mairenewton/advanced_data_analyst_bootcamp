  view: order_facts {
    derived_table: {
      sql: SELECT
              oi.order_id,
              oi.user_id,
              count(*) as order_item_count,
              sum(oi.sale_price) as order_total
              from public.order_items oi
              group by 1,2
              order by 3 desc;;
    }

    measure: count_of_orders {
      type: count
      drill_fields: [detail*]
    }

    dimension: order_id {
      type: number
      sql: ${TABLE}.order_id ;;
    }

    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension: order_item_count {
      type: number
      sql: ${TABLE}.order_item_count ;;
    }

    dimension: order_total {
      type: number
      sql: ${TABLE}.order_total ;;
    }

    set: detail {
      fields: [order_id, user_id, order_item_count, order_total]
    }
  }
