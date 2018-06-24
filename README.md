# Bitcoin
Code used for the yearly calculations of CO2e from Bitcoin mining.

Approach:
1. Collect the data of all blocks mined in 2017. For this use code: "03 Get data on BitCoin.r". The resulting data are already provided here in the file: "BitCoinData_2017.csv".
2. Download the databases on mining hardware (Randi_TableS1.csv) and CO2e emmisions of electricity generation in countries doing mining in 2017 (Katie_TableS2.csv).
3. Run code (05 Carbon Bitcoin 2017.r), which will use the databases above to stimate carbon emmisions of Bitcoin mining in 2017.
