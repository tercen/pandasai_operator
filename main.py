# from tercen.client import context as ctx
# import numpy as np

# tercenCtx = ctx.TercenContext()

# df = (
#     tercenCtx
#     .select(['.y', '.ci', '.ri'], df_lib="pandas")
#     .groupby(['.ci','.ri'], as_index=False)
#     .mean()
#     .rename(columns={".y":"mean"})
#     .astype({".ci": np.int32, ".ri": np.int32})
# )

# df = tercenCtx.add_namespace(df) 
# tercenCtx.save(df)
import pandas as pd
import os
from pandasai import SmartDataframe
from pandasai.llm.local_llm import LocalLLM
from langchain_community.llms import Ollama
from pandasai.llm import OpenAI
import matplotlib
matplotlib.use(backend="Agg")


sales_by_country = pd.DataFrame({
    "country": ["United States", "United Kingdom", "France", "Germany", "Italy", "Spain", "Canada", "Australia", "Japan", "China"],
    "sales": [5000, 3200, 2900, 4100, 2300, 2100, 2500, 2600, 4500, 7000]
})
#TODO the smartdataframe from DF directly
# df.to_csv("data.csv")

#os.environ['PANDASAI_API_KEY']="SOME_KEY"

#llm = LocalLLM(api_base="http://localhost:11434/v1", model="mistral")
llm = OpenAI(api_token="OpenAIKEY")


# ollama_llm = Ollama(model="mistral")  
# df = SmartDataframe("data.csv", config={"llm": ollama_llm})
df = SmartDataframe(sales_by_country, config={"llm": llm, "enable_cache": False})
# imgBytes = df.chat('What are the 5 highest countries by sale?')
imgBytes = df.chat('Make a vertical bar plot of the 5 highest countries by sale in 4k pixels. Increase font size of the x and y ticks')
print(".")
print(".")

#127.0.0.1:11434
