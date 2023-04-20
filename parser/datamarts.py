"""Федеральное казначейство. МЕЖБЮДЖЕТНЫЕ ТРАНСФЕРТЫ СУБЪЕКТАМ РФ."""
import json
import time
import pandas as pd

from requests import request

base_url = "http://datamarts.roskazna.ru/razdely/rashody/mezhbudgetnye-transferty/" \
           "mezhbudgetnye-transferty-subjektam-rf/redirect/localhost/Data?"

money_code_pattern = {
    "0170558300",
    "0170558330",
    "0320558340",
    "1520158310",
    "01К0756810",
    "3620258320",
    "3620258440",
    "3620258570",
    "3620258530",
    "3620258480",
    "3620258550",
    "01К0658120",
    "01К0756100",
    "01К0756080",
    "01К0658110",
    "01К0658350",
    "01К0658420",
    "01К0658450",
    "01К0658460",
    "01К0758460",
    "01К0958430",
    "35Г0458460",
    "01К0652020",
    "0170558360",
    "0320558370",
    "01К1058410",
    "0311252400",
    "01К0554020",
    "01К0756230",
    "01К0758230",
}

money_code_pattern_21 = {
    "0320558370",
    "01К0656640",
    "01К0658450",
    "01К0658460",
    "01К0958430",
    "01К1056220",
    "01К1058490",
    "0170556970",
    "0170558360",
    "35Г0458460",
    "3620258440",
    "01К0652020",
    "01К0654230",
    "01К0753470",
    "0311252400",
    "01К0554020",
    "01К0756630",
    "01К0756670",
    "01К0756080",
    "01К0756100",
    "01К1058400",
    "01К1058410",
}

money_code_for_all = [
    "x"
]

all_periods = [x for x in range(2016, 2022)]


def download_data():
    result_object_download = {}
    response = request(
        method="GET",
        url=base_url,
        params={
            "uuid": "528be0bd-54a5-43ca-bbcf-f5464c9187d",
            "dataVersion": "03.09.2015 05.14.55.000",
            "dsCode": "DTM_0001_0048_terrData",
            "DataMartStelsXMLOnce_paramPeriod": "2015-01-01T00%3A00%3A00.000Z",
            "_dc": "1680552475418"
        }
    )
    all_district = response.json()["data"][2:]

    for period in all_periods:
        territories = 8
        for district_name, district_code, _ in all_district:
            print(period, district_name)
            if district_code < 10 and district_code != territories:
                print(f"Switch to {district_name} and {district_code}")
                territories = district_code
                continue
            response = request(
                method="POST",
                url=base_url,
                params={
                    "uuid": "528be0bd-54a5-43ca-bbcf-f5464c9187d",
                    "dataVersion": "03.09.2015 05.14.55.000",
                    "dsCode": "DTM_0001_0048_kcsrGridData",
                    "DTM_0001_0048_paramTerritories": district_code,
                    "paramRubMultipleDTM": 1000000,
                    "DTM_0001_0048_paramTerritoriesHidden": territories,
                    "paramPeriod": f"{period}-04-02T21%3A00%3A00.000Z",
                    "_dc": "1680552475477",
                }
            )
            district_money_info = response.json()["data"]
            if period not in result_object_download.keys():
                result_object_download[period] = {}
            result_object_download[period][district_name] = district_money_info
            time.sleep(0.3)
    return result_object_download


def dump_to_file(obj, filename="./data/result.json"):
    with open(filename, "w") as result_file:
        json.dump(obj, result_file, indent=4, ensure_ascii=False)


def load_file(filename="./data/esult.json"):
    with open(filename, "r") as f:
        return json.load(f)


def create_df_and_dump():
    dataset: dict = load_file(filename="./data/loaded_data_16_to_21_v3.json")
    with pd.ExcelWriter(f'output-{int(time.time())}.xlsx') as writer:
        for period, districts in dataset.items():
            cur_df = pd.DataFrame(columns=list(money_code_for_all), index=districts.keys())
            for district_name, district_data in districts.items():
                print(period, district_name)
                for data in district_data:
                    money_code = data[1]
                    # money_name = data[3]
                    value = data[5]
                    if money_code and money_code.lower() in money_code_for_all:
                        cur_df.loc[district_name, money_code] = value
                    cur_df.to_excel(writer, sheet_name=period)


if __name__ == "__main__":
    # result_object = download_data()
    # dump_to_file(result_object, filename="./data/loaded_data_16_to_21_v3.json")
    create_df_and_dump()
