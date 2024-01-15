# market_app_info
AppStore Maker Information.
(Now only AppStore)

## Parameters
### Inputs

|Parameter|Description|Required|Default|Type|
|:---|:---|:---|:---|:---|
|bundle_identifier|Application Bundle Identifier|false|-|string|
|version_number|Application Version Number|false|-|string|
|country_code|Country Code using lookup API|false|jp|string|


### Outputs

|Name|Description|
|:-------|:----------|
|steps.{your_step_id}.outputs.app_name|Application App Name|
|steps.{your_step_id}.outputs.release_date|Application Release Date|
|steps.{your_step_id}.outputs.version|Application Version|


## Usage Examples

```
jobs:
  sample:
    runs-on: ubuntu-latest
    steps:
      - name: AppStore Information
        id: appstore_information
        uses: tarappo/market_app_info@v1.1.0
        with:
          bundle_identifier: "Your Application Bundle Identifier"
      - name: Ouputs
        run: |
          echo ${{ steps.appstore_information.outputs.app_name }}
          echo ${{ steps.appstore_information.outputs.release_date }}
          echo ${{ steps.appstore_information.outputs.version }}
```
