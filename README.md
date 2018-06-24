# Bitcoin
Codes and data used for the yearly calculations of CO2e from Bitcoin mining.

Approach:
1. Collect the data of all blocks mined in 2017. For this, use code: "03 Get data on BitCoin.r". The resulting data are already provided here in the file: "BitCoinData_2017.csv".
2. Download the databases on mining hardware (Randi_TableS1.csv) and CO2e emissions of electricity generation in countries doing mining in 2017 (Katie_TableS2.csv).
3. Run code (05 Carbon Bitcoin 2017.r), which will use the databases above to estimate carbon emissions of Bitcoin mining in 2017.

For Bitcoin emission projections, we used three alternative scenarios of how broadly used technologies have been incorporated by society (raw data in Code09_Threescenarios_FitsTechonologyAdoption.csv), and calculated emissions should Bitcoin usage follow any of such pathways. 

Proportions in the adoption of technologies were converted to transactions assuming a global number of cashless transactions of 314,210,898,142 [WorldBank. Global Payment Systems Survey 2016. (Accessed February 28, 2018)]. At each time step, CO2e emissions for the given number of transactions were estimated based on the emissions generated to mine that number of transactions in 2017.
