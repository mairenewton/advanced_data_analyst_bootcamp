- dashboard: age_analysis
  title: Age Analysis
  layout: newspaper
  elements:
  - title: Total Sales per Age Group
    name: Total Sales per Age Group
    model: advanced_data_analyst_bootcamp
    explore: order_items
    type: looker_grid
    fields: [total_sales, average_sales, users.country, users.age_tier]
    pivots: [users.country]
    sorts: [users.country 0, users.age_tier]
    limit: 500
    dynamic_fields: [{dimension: shipping_days, label: Shipping Days, expression: 'diff_days(${order_items.shipped_date},${order_items.delivered_date})',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
        _type_hint: number}, {dimension: city_state, label: City State, expression: 'concat(${users.city},"
          ,",${users.state})', value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: string}, {dimension: is_email_source, label: Is
          Email Source, expression: '${users.traffic_source}= "Email"', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: dimension, _type_hint: yesno}, {
        measure: distinct_number_of_orders, based_on: order_items.order_id, type: count_distinct,
        label: Distinct Number Of Orders, expression: !!null '', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        measure: total_sales, based_on: order_items.sale_price, type: sum, label: Total
          Sales, expression: !!null '', value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}, {measure: average_sales, based_on: order_items.sale_price,
        type: average, label: Average Sales, expression: !!null '', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        measure: total_sales_email_user, based_on: order_items.sale_price, type: sum,
        label: Total Sales Email User, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number, filter_expression: '${users.traffic_source}
          = "Email"'}]
    query_timezone: America/New_York
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    show_null_points: true
    row: 0
    col: 0
    width: 8
    height: 6
