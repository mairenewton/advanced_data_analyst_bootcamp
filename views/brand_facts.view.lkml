# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

view: brand_facts {
  derived_table: {
    explore_source: order_items {
      column: product_brand { field: inventory_items.product_brand }
      column: total_revenue {}
      derived_column: brand_rank {
        sql: row_number() over (order by total_revenue desc) ;; }
    }
  }
  dimension: product_brand {}
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: brand {
    primary_key: yes
    sql: ${TABLE}.product_brand ;;
  }

  dimension: brand1 {
    type: string
    sql: ${TABLE}.product_brand || '1' ;;
    drill_fields: [brand2]
  }

  dimension: brand2 {
    type: string
    sql: ${TABLE}.product_brand || '2' ;;
    drill_fields: [brand1]
  }

  dimension: brand_rank {
    type: number
    sql: ${TABLE}.brand_rank ;;
  }

  dimension: brand_rank_concat {
    type: string
    sql: ${brand} || ':)' || ${brand_rank} ;;
  }

  dimension: brand_rank_top_5 {
    hidden: yes
    type: yesno
    sql: ${brand_rank} <=5  ;;
  }

  dimension: brand_rank_group {
    type: string
    label_from_parameter: "test"
    sql: case when ${brand_rank_top_5} then ${brand_rank_concat}
    else 'other :) 6' end
    ;;
  }

  parameter: test {
    type: unquoted
    allowed_value: {
      label: "brand1"
      value: "brand1"
    }
    allowed_value: {
      label: "brand2"
      value: "brand2"
    }
  }

  dimension: brand_common {
    type: string
    sql: {% if test._parameter_value == 'brand1'  %}
          ${brand1}
        {% elsif test._parameter_value == 'brand2'  %}
          ${brand2}
        {% endif %}
    ;;
  }




}
