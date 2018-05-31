view: order_items {
  sql_table_name: public.order_items ;;

  parameter: select_a_timeframe {
    label: "choose a timeframe"
    description:"select a timeframe for viewing the data"
    type: string
    allowed_value: {
      label:  "Year"
      value: "year"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
  }

  dimension: dynamic_timeframe {
    label_from_parameter: select_a_timeframe
    sql:
    CASE WHEN {%parameter select_a_timeframe %} = 'month' THEN ${created_month}
     WHEN {%parameter select_a_timeframe %} = 'week' THEN ${created_week}
    ELSE TO_CHAR(${created_year}, '9999')
    END
          ;;

  }

      parameter: select_a_measure {
      default_value: "total_revenue"
        allowed_value: {
          label:"Total Revenue"
          value: "total_revenue"
        }
        allowed_value: {
          label:"Order Count"
          value: "order_count"
        }
        allowed_value: {
          label:"Average Sales Price"
          value: "average_sales_price"
        }

      }

      measure: dynamic_measure {
        sql: CASE WHEN {% parameter select_a_measure %} = 'total_revenue'
                  THEN ${total_revenue}
                  WHEN  {%parameter select_a_measure %} = 'order_count'
                  THEN ${order_count}
                  ELSE ${average_sale_price}
                  END
                  ;;
      value_format_name: decimal_2
      }



      dimension: id {
        hidden:  yes
        primary_key: yes
        type: number
        sql: ${TABLE}.id ;;
      }

      dimension_group: created {
        description: "When the order was created"
        type: time
        timeframes: [
          raw,
          time,
          date,
          week,
          month,
          month_num,
          quarter,
          year
        ]
        sql: ${TABLE}.created_at ;;
      }

      dimension_group: delivered {
        description: "When the order was delivered"
        type: time
        timeframes: [
          raw,
          time,
          date,
          week,
          month,
          quarter,
          year
        ]
        sql: ${TABLE}.delivered_at ;;
      }

      dimension_group: returned {
        description: "When the order was returned"
        type: time
        timeframes: [
          raw,
          time,
          date,
          week,
          month,
          quarter,
          year
        ]
        sql: ${TABLE}.returned_at ;;
      }

      dimension: sale_price {
        type: number
        value_format_name: usd
        sql: ${TABLE}.sale_price ;;
      }

      dimension_group: shipped {
        description: "When the order was shipped"
        type: time
        timeframes: [
          raw,
          time,
          date,
          week,
          month,
          quarter,
          year
        ]
        sql: ${TABLE}.shipped_at ;;
      }

      dimension: status {
        description: "Whether order is processing, shipped, completed, etc."
        type: string
        sql: ${TABLE}.status ;;
      }

      dimension: shipping_time {
        description: "Shipping time in days"
        type: number
        sql: DATEDIFF(day, ${order_items.shipped_date}, ${order_items.delivered_date}) ;;
      }

## HIDDEN DIMENSIONS ##

      dimension: inventory_item_id {
        hidden:  yes
        type: number
        # hidden: yes
        sql: ${TABLE}.inventory_item_id ;;
      }

      dimension: order_id {
#     hidden:  yes
      type: number
      sql: ${TABLE}.order_id ;;
    }

    dimension: user_id {
      type: number
      hidden: yes
      sql: ${TABLE}.user_id ;;
    }

    dimension: profit {
      description: "Profit made on any one item"
      hidden:  yes
      type: number
      value_format_name: usd
      sql: ${sale_price} - ${inventory_items.cost} ;;
    }

## MEASURES ##

    measure: order_item_count {
      type: count
      drill_fields: [detail*]
    }

    measure: total_revenue {
      type: sum
      value_format_name: usd
      sql: ${sale_price} ;;
      drill_fields: [detail*]
    }

    measure: order_count {
      description: "A count of unique orders"
      type: count_distinct
      sql: ${order_id} ;;
    }

    measure: average_sale_price {
      type: average
      value_format_name: usd
      sql: ${sale_price} ;;
      drill_fields: [detail*]
    }

    measure: average_spend_per_user {
      type: number
      value_format_name: usd
      sql: 1.0 * ${total_revenue} / NULLIF(${users.count},0) ;;
    }

    measure: total_profit {
      type: sum
      sql: ${profit} ;;
      value_format_name: usd
    }

    measure: profit_margin {
      type: number
      sql: ${total_profit}/NULLIF(${total_revenue}, 0) ;;
      value_format_name: percent_2
    }

    measure: average_shipping_time {
      type: average
      sql: ${shipping_time} ;;
      value_format: "0\" days\""
    }


    # ----- Sets of fields for drilling ------
    set: detail {
      fields: [
        id,
        users.id,
        users.first_name,
        users.last_name,
        inventory_items.id,
        inventory_items.product_name
      ]
    }
  }
