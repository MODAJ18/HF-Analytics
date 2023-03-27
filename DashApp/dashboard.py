from dash import Dash, html, dcc, Input, Output
import plotly.express as px
import psycopg2 
from psycopg2.extras import execute_values
import numpy as np
import pandas as pd
import dask.dataframe as dd
app = Dash(__name__)

if __name__ == '__main__':
    print("Dashboard SETUP - start")

    # definitions
    sql_select_data = """
        SELECT vf.visit_id,
            ppd.pr_id,
            hfd.oshpd_id2,
            hfd.location_id,
            pd.p_id,
            ed.emp_id,
            ppd.name as procedure_name,
            ppd.type as procedure_type,
            ppd.price as procedure_price,
            hfd.name as health_facility_name,
            hfd.city as health_facility_city,
            hfd.county as health_facility_county,
            hfd.license_type as health_facility_license_type,
            pd.name as patient_name,
            pd.date_of_birth as patient_dob,
            ed.emp_name as employee_name,
            ed.section as employee_section,
            ed.specialty as employee_specialty,
            vf.visit_date,
            vf.payment as visit_payment,
            vf.rating as visit_rating
        FROM VisitFact vf
        INNER JOIN PatientProcedureDim ppd ON vf.procedure_dim_id = ppd.pr_id
        INNER JOIN HealthFacilityDim hfd ON (vf.health_facility_dim_id_fac=hfd.oshpd_id2) AND (vf.health_facility_dim_id_loc=hfd.location_id)
        INNER JOIN PatientDim pd ON vf.patient_dim_id=pd.p_id
        INNER JOIN EmployeeDim ed ON vf.employee_dim_id=ed.emp_id;  
        """
    data_cols = ["visit_id", "pr_id", "oshpd_id2", "location_id", "p_id", "emp_id", "procedure_name", "procedure_type",
                "procedure_price", "health_facility_name", "health_facility_city", "health_facility_county",
                "health_facility_license_type", "patient_name", "patient_dob", "employee_name", "employee_section",
                "employee_specialty", "visit_date", "visit_payment", "visit_rating"]

    # starting connection to DB - CONFIG REQUIRED
    user = "postgres"
    password = "<PASSWORD>"
    conn = psycopg2.connect(
            host="localhost",
            database="hospital_olap_db",
            user=user,
            password=password)
    curr = conn.cursor()
    curr.execute(sql_select_data)
    
    # building dask dataframe
    ddf = dd.from_array(np.array(curr.fetchall()), chunksize=10000, columns=data_cols)
    ddf['visit_date'] = dd.to_datetime(ddf['visit_date'])
    min_year = ddf['visit_date'].min().compute().year
    max_year = ddf['visit_date'].max().compute().year
    years = list(map(lambda x: str(x), range(min_year, max_year + 1)))
    unique_procedures = ddf['procedure_name'].unique().compute()

    # closing db connection
    curr.close()
    conn.close()
    print("Dashboard SETUP - end")

## 2 - Components




## 3 - layout
app.layout = html.Div([
    html.Div([
        html.H1(children='Health Facilities - Dashboard')
    ], style={"textAlign": "center", "backgroundColor":"#2EC0F9", "border-radius": "10px", 
                "border": "solid 3px #67AAF9", "marginTop": "5px", "marginLeft": "7px", "marginRight": "7px"}),
    html.Div([
        html.Div([
            html.Div([
                dcc.Slider(
                    min_year,
                    max_year,
                    step=None,
                    value=min_year,
                    marks={str(year): str(year) for year in years},
                    id='year-slider',

                ),
                dcc.Graph(
                    id='pvgr-fig'
                )
            ], style={'width': '48%', 'display': 'inline-block'}),
            html.Div([
                dcc.Dropdown(
                    unique_procedures,
                    unique_procedures[:3],
                    id='health-facility-fil',
                    multi=True,
                    className='dropdown'
                ),
                dcc.Graph(
                    id='hvot-fig'
                )   
            ], style={'width': '48%', 'float': 'right', 'display': 'inline-block'})
        ], style={"marginTop": "50px"}),
        html.Div([
            html.Div([
                dcc.Graph(
                    id='hvbp-fig'
                ) 
            ], style={'width': '48%', 'display': 'inline-block'}),
            html.Div([
                dcc.Graph(
                    id='mep-fig'
                ) 
            ], style={'width': '48%', 'float': 'right', 'display': 'inline-block'})
        ])
    ], style={"paddingRight": "30px", "paddingLeft": "30px", "paddingBottom": "0px", 
                "marginBottom": "10px", "marginLeft": "7px", "marginRight": "7px",
                "border-radius": "10px", "border": "solid 3px #67AAF9", "backgroundColor": "white"}),
    
    # intermediate store
    dcc.Store(id='intermediate-value')
], id='container')


## 4 - Callbacks
@app.callback(Output('intermediate-value', 'data'), 
                Input('year-slider', 'value'),
                Input('health-facility-fil', 'value'))
def clean_data(selected_year, health_facility_cities):
     filtered_ddf = ddf[(ddf['visit_date'].dt.year == selected_year) &
                            (ddf['procedure_name'].isin(health_facility_cities))].compute()
     return filtered_ddf.to_json(date_format='iso', orient='split')


@app.callback(
    Output('pvgr-fig', 'figure'),
    Input('intermediate-value', 'data'))
def update_figure_pvgr(filtered_ddf_json): 
    filtered_ddf = pd.read_json(filtered_ddf_json, orient='split')
    data_used = filtered_ddf.groupby(['visit_rating', 'health_facility_license_type']).count().iloc[:, :1]\
                    .reset_index().rename(columns={"visit_id": "count"})
    fig = px.bar(data_used, x="visit_rating", y=data_used['count'].tolist(), 
             color="health_facility_license_type", text_auto=True, color_discrete_sequence=px.colors.qualitative.Prism,
             title="Visit Rating Counts - Selected Facilities")
    fig.update_layout(
        xaxis_type='category'
    )
    return fig

@app.callback(
    Output('hvot-fig', 'figure'),
    Input('intermediate-value', 'data'))
def update_figure_hvot(filtered_ddf_json):
    filtered_ddf = pd.read_json(filtered_ddf_json, orient='split')
    data_used = filtered_ddf.groupby(['visit_date']).count().iloc[:, :1].\
                reset_index().rename(columns={"visit_id": "visit_count"})
    fig = px.line(data_used, x='visit_date', y="visit_count", title="Hospital Visits - over time",
     color_discrete_sequence=px.colors.qualitative.Prism)
    return fig

@app.callback(
    Output('hvbp-fig', 'figure'),
    Input('intermediate-value', 'data'))
def update_figure_hvbp(filtered_ddf_json):
    filtered_ddf = pd.read_json(filtered_ddf_json, orient='split')
    data_used = filtered_ddf.groupby(['procedure_type']).count()[["visit_id"]].\
                    reset_index().rename(columns={"visit_id": "visit_count"}).sort_values(["visit_count"])
    fig = px.bar(data_used, x='visit_count', y='procedure_type', text_auto=True, 
        title='Hospital Visits by Procedure', color='visit_count')
    return fig

@app.callback(
    Output('mep-fig', 'figure'),
    Input('intermediate-value', 'data'))
def update_figure_mep(filtered_ddf_json):
    filtered_ddf = pd.read_json(filtered_ddf_json, orient='split')
    data_used = filtered_ddf[["procedure_name", "visit_payment"]].groupby("procedure_name")[["visit_payment"]].sum().\
        reset_index().sort_values(['visit_payment'], ascending=False)[:10] 
    fig = px.pie(data_used, values='visit_payment', names='procedure_name', 
                    title='Patient Procedures - Aggregate Paymets')
    return fig



if __name__ == '__main__':
    app.run_server(debug=False)



