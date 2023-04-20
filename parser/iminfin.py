"""iMonitoring."""
import json
import time

import pandas as pd
from requests import request

from datamarts import dump_to_file, load_file

url = "https://www.iminfin.ru/areas-of-analysis/budget/redirect/copen-imon/Data?"

method = "POST"
params = {
    "uuid": "77b109a3-1c64-42db-9f58-6d79b42ba198",
    "dataVersion": "30.05.2018%2006.53.20.37",
    "dsCode": "PassportFK_001_001_incomesGridData",
    "territory": "45000000",
    "paramPeriod": "-12-01T00:00:00.000Z",
    "_dc": "1681894186765"
}

all_regions_params = {
    "uuid": "44de5f93-33df-4c8f-9a24-478a0d60fc47",
    "dataVersion": "30.05.2018 06.53.20.378",
    "dsCode": "TerritoryOnlySubject",
    "TERRITORIES_paramPeriod": "2014-05-28T00:00:00.000Z",
    "_dc": "1681895469737"
}

topics = [
    "Безвозмездные поступления от других бюджетов бюджетной системы Российской Федерации",
    "доля межбюджетных трансфертов из федерального бюджета (за исключением субвенций) в доходах",
    "Дотации, в т.ч.",
    "на выравнивание бюджетной обеспеченности",
    "на поддержку мер по обеспечению сбалансированности бюджетов",
    "Субсидии, в т.ч.",
    "капитального характера",
    "Субвенции",
    "Иные межбюджетные трансферты"
]
topics_pos = [17, 26]
data_idx = 11


def load_iminfin_regions_code(filename="./data/iminfin_regions_code.json") -> list[list[str]]:
    with open(filename, "r") as f:
        regions = json.loads(f.read())["data"]
    return regions


def fetch_data_from_iminfin(regions: list[list[str]]) -> dict[int, dict[str, list]]:
    result = {}
    for period in range(2016, 2022):
        print(period)
        result[period] = {}
        for code, name, _ in regions:
            print(code, name)
            response = request(
                method="POST",
                url=url,
                params={
                    "uuid": "44de5f93-33df-4c8f-9a24-478a0d60fc47",
                    "dataVersion": "30.05.2018 06.53.20.378",
                    "dsCode": "PassportFK_001_001_incomesGridData",
                    "territory": code,
                    "paramPeriod": f"{period}-12-01T00:00:00.000Z",
                    "_dc": "1681894186765"
                }
            )
            result[period][name] = response.json()["data"][topics_pos[0]: topics_pos[1]]
    return result


def create_df_and_dump():
    dataset: dict = load_file(filename="./data/iminfin-1681917702.json")
    with pd.ExcelWriter(f'iminfin-output-{int(time.time())}.xlsx') as writer:
        for period, districts in dataset.items():
            cur_df = pd.DataFrame(columns=topics, index=districts.keys())
            for district_name, district_data in districts.items():
                print(period, district_name)
                for data in district_data:
                    column_name = data[0]
                    value = data[data_idx]
                    cur_df.loc[district_name, column_name] = value
            cur_df.to_excel(writer, sheet_name=period)


if __name__ == "__main__":
    # r_codes = load_iminfin_regions_code()
    # districts_info_by_data = fetch_data_from_iminfin(r_codes)
    # dump_to_file(obj=districts_info_by_data, filename=f"./data/iminfin-{int(time.time())}.json")
    create_df_and_dump()
