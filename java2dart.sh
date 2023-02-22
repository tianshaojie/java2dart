file=$1
oldsuffix="java"
newsuffix="dart"

change_suffix() {
   targetFile=$1
   if [ "${targetFile##*.}"x = "${oldsuffix}"x ]
   then
      name=$(ls ${targetFile} | cut -d. -f1)
      newfile=${name}.${newsuffix}
      mv $targetFile $newfile
      echo $newfile
   else
      echo $targetFile
   fi
}

java2dart() {
   java2dartFile=$(change_suffix $1)
   echo "============================================="

  echo "开始对文件 $java2dartFile 进行替换"
  echo "---------------------------------------------"

  sed -i "/^package /d" "$java2dartFile"
  sed -i "/^import com.mitake./d" "$java2dartFile"
  sed -i "/^import java./d" "$java2dartFile"
  sed -i "/^import android./d" "$java2dartFile"
  sed -i "/^import org.json./d" "$java2dartFile"
  echo "==>删除import/package的引用"
  echo "---------------------------------------------"


  # 继承Request的类，添加import，这些是重复工作
  # if [ `grep -c "extends Request" "$java2dartFile"` -ne '0' ];then
  #   # 重复执行时，先删后加
  #   sed -i "/^import /d" "$java2dartFile"

  #   sed -i "1 a\\import '../AppInfo.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../HeaderType.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../bean/log/ErrorInfo.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../keys/ErrorCodes.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../keys/ErrorMsg.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../keys/f10/F10ParamKeys.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../network/HttpData.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../network/HttpHeaderKey.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../network/IRequestCallback.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../permission/MarketPermission.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../response/IResponseCallback.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../util/ApiHttp.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../util/ExchangeUtil.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../util/KeysUtil.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../util/Log.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../util/TextUtils.dart';" "$java2dartFile"
  #   sed -i "1 a\\import '../util/StockCatagoryUtil.dart';" "$java2dartFile"
  #   sed -i "1 a\\import 'Request.dart';" "$java2dartFile"
  #   echo "继承Request的类，添加import"
  #   echo "---------------------------------------------"
  # fi

  sed -i "s/ interface / class /g" "$java2dartFile"
  sed -i "s/public //g" "$java2dartFile"
  sed -i "s/protected //g" "$java2dartFile"
  sed -i "s/private //g" "$java2dartFile"
  sed -i "s/@Deprecated//g" "$java2dartFile"
  sed -i "s/@Override/@override/g" "$java2dartFile"
  echo "==>删除public/protected/private/@Deprecated关键字"
  echo "---------------------------------------------"

  #Integer.valueOf, Integer.parseInt
  sed -i "s/Integer.valueOf/int.parse/g" "$java2dartFile"
  sed -i "s/Integer.parseInt/int.parse/g" "$java2dartFile"
  sed -i "s/Integer.toString/StringUtil.parseString/g" "$java2dartFile"

  #String.valueOf
  sed -i "s/String.valueOf/StringUtil.parseString/g" "$java2dartFile"

  #Long.valueOf, Long.parseInt
  sed -i "s/Long.valueOf/int.parse/g" "$java2dartFile"
  sed -i "s/Long.parseLong/int.parse/g" "$java2dartFile"
  sed -i "s/Long.toString/StringUtil.parseString/g" "$java2dartFile"

  #Double.valueOf, Double.parseInt
  sed -i "s/Double.valueOf/double.parse/g" "$java2dartFile"
  sed -i "s/Double.parseDouble/double.parse/g" "$java2dartFile"
  sed -i "s/Double.toString/StringUtil.parseString/g" "$java2dartFile"

  #Float.valueOf, Float.parseInt
  sed -i "s/Float.valueOf/double.parse/g" "$java2dartFile"
  sed -i "s/Float.parseFloat/double.parse/g" "$java2dartFile"
  sed -i "s/Float.toString/StringUtil.parseString/g" "$java2dartFile"

  #Boolean.valueOf, Boolean.parseInt
  sed -i "s/Boolean.valueOf/StringUtil.parseBool/g" "$java2dartFile"
  sed -i "s/Boolean.parseBoolean/StringUtil.parseBool/g" "$java2dartFile"
  sed -i "s/Boolean.toString/StringUtil.parseString/g" "$java2dartFile"

  echo "==>Integer/String/Long/Double/Float/Boolean替换"
  echo "---------------------------------------------"

  #echo 'send(CateType.SH1001, "", new byte[]{QuoteCustomField.ALL_COLUMN}, new byte[]{QuoteCustomField.ALL_COLUMN});' | sed "s/new byte\[\] *{\(.*\)},.*new byte\[\] *{\(.*\)}/Uint8List.fromList([\1]), Uint8List.fromList([\2])/g"
  #echo 'byte[] b = new byte[] {1}' | sed "s/new byte\[\] *{\(.*\)}/Uint8List.fromList([\1])/g" | sed 's/byte\[\]/Uint8List/g'
  sed -i "s/new byte\[\] *{\(.*\)},.*new byte\[\] *{\(.*\)}/Uint8List.fromList([\1]), Uint8List.fromList([\2])/g" "$java2dartFile"
  sed -i "s/new byte\[\] *{\(.*\)}/Uint8List.fromList([\1])/g" "$java2dartFile"
  #echo 'byte[] b = new byte[c.length*2];' | sed 's/new byte\[\(.*\)\]/Uint8List(\1)/g' | sed 's/byte\[\]/Uint8List/g'
  sed -i "s/new byte\[\(.*\)\]/Uint8List(\1)/g" "$java2dartFile"
  sed -i "s/byte\[\]/Uint8List/g" "$java2dartFile"
  echo "==>byte[]替换为Uint8List"
  echo "---------------------------------------------"

  #echo 'send(CateType.SH1001, "", new int[]{QuoteCustomField.ALL_COLUMN}, new int[]{QuoteCustomField.ALL_COLUMN});' | sed 's/new int\[\] *{\(.*\)},.*new int\[\] *{\(.*\)}/Int32List.fromList([\1]), Int32List.fromList([\2])/g'
  #echo 'QuoteTypeCode.getQuoteMustColumns(new int[]{QuoteCustomField.quote_NAME})' | sed 's/new int\[\] *{\(.*\)}/Int32List.fromList([\1])/g'
  #echo 'int[] a = new int[] {1, 2};' | sed "s/new int\[\] *{\(.*\)}/Int32List.fromList([\1])/g" | sed "s/int\[\]/Int32List/g"
  #echo 'int[] a = new int[length];' | sed "s/new int\[\(.*\)\]/Int32List(\1)/g" | sed "s/int\[\]/Int32List/g"
  sed -i "s/new int\[\] *{\(.*\)},.*new int\[\] *{\(.*\)}/Int32List.fromList([\1]), Int32List.fromList([\2])/g" "$java2dartFile"
  sed -i "s/new int\[\] *{\(.*\)}/Int32List.fromList([\1])/g" "$java2dartFile"
  sed -i "s/new int\[\(.*\)\]/Int32List(\1)/g" "$java2dartFile"
  sed -i "s/int\[\]/Int32List/g" "$java2dartFile"
  echo "==>int[]替换为Int32List"
  echo "---------------------------------------------"


  #echo 'long[] a = new long[] {1, 2};' | sed "s/new long\[\] *{\(.*\)}/Int64List.fromList([\1])/g" | sed "s/long\[\]/Int64List/g"
  #echo 'long[] a = new long[length];' | sed "s/new long\[\(.*\)\]/Int64List(\1)/g" | sed "s/long\[\]/Int64List/g"
  sed -i "s/new long\[\] *{\(.*\)},.*new long\[\] *{\(.*\)}/Int64List.fromList([\1]), Int64List.fromList([\2])/g" "$java2dartFile"
  sed -i "s/new long\[\] *{\(.*\)}/Int64List.fromList([\1])/g" "$java2dartFile"
  sed -i "s/new long\[\(.*\)\]/Int64List(\1)/g" "$java2dartFile"
  sed -i "s/long\[\]/Int64List/g" "$java2dartFile"
  echo "==>long[]替换为Int64List"
  echo "---------------------------------------------"


  #echo 'float[] a = new float[] {1.1, 2.2};' | sed "s/new float\[\] *{\(.*\)}/Float32List.fromList([\1])/g" | sed "s/float\[\]/Float32List/g"
  sed -i "s/new float\[\] *{\(.*\)},.*new float\[\] *{\(.*\)}/Float32List.fromList([\1]), Float32List.fromList([\2])/g" "$java2dartFile"
  sed -i "s/new float\[\] *{\(.*\)}/Float32List.fromList([\1])/g" "$java2dartFile"
  sed -i "s/new float\[\(.*\)\]/Float32List(\1)/g" "$java2dartFile"
  sed -i "s/float\[\]/Float32List/g" "$java2dartFile"
  echo "==>float[]替换为Float32List"
  echo "---------------------------------------------"


  #echo 'double[] a = new double[] {1.1, 2.2};' | sed "s/new double\[\] *{\(.*\)}/Float64List.fromList([\1])/g" | sed "s/double\[\]/Float64List/g"
  sed -i "s/new double\[\] *{\(.*\)},.*new double\[\] *{\(.*\)}/Float64List.fromList([\1]), Float64List.fromList([\2])/g" "$java2dartFile"
  sed -i "s/new double\[\] *{\(.*\)}/Float64List.fromList([\1])/g" "$java2dartFile"
  sed -i "s/new double\[\(.*\)\]/Float64List(\1)/g" "$java2dartFile"
  sed -i "s/double\[\]/Float64List/g" "$java2dartFile"
  echo "==>double[]替换为Float64List"
  echo "---------------------------------------------"


  #echo 'new String[commandMap.length][2];' | sed 's/s/new String\[.*\]\[.*\]/{}/g/g'
  #echo 'new String[mIPType.length][];' | sed 's/new String\[.*\]\[.*\]/{}/g/g'
  #echo 'new String[][]{{HeaderType.TOKEN, AppInfo.token}, {HeaderType.SYMBOL, code}};' | sed 's/new String\[.*\]\[.*\]/{}/g'
  sed -i "s/new String\[.*\]\[.*\]/{}/g" "$java2dartFile"
  #echo 'String[][] command' | sed 's/String\[\]\[\] /Map<String, String> /g'
  sed -i "s/String\[\]\[\] /Map<String, String> /g" "$java2dartFile"
  #String[][] command = new String[][]{{HeaderType.TOKEN, AppInfo.token}, {HeaderType.SYMBOL, code}};
  #echo '{{HeaderType.TOKEN, AppInfo.token}, {HeaderType.SYMBOL, code}, {HeaderType.SYMBOL, code}, {HeaderType.SYMBOL, code}};' | sed "s/{{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}}/{\1:\2, \3:\4, \5:\6, \7:\8}/g"
  #echo '{{HeaderType.TOKEN, AppInfo.token}, {HeaderType.SYMBOL, code}, {HeaderType.SYMBOL, code}};' | sed "s/{{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}}/{\1:\2, \3:\4, \5:\6}/g"
  #echo 'new String[][]{{HeaderType.TOKEN, AppInfo.token}, {HeaderType.SYMBOL, code}};'| sed 's/new String\[.*\]\[.*\]/{}/g' | sed "s/{}{{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}}/{\1:\2, \3:\4}/g"
  sed -i "s/{}{{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}}/{\1:\2, \3:\4, \5:\6, \7:\8}/g" "$java2dartFile"
  sed -i "s/{}{{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}}/{\1:\2, \3:\4, \5:\6}/g" "$java2dartFile"
  sed -i "s/{}{{\(.*\),\(.*\)}, *{\(.*\),\(.*\)}}/{\1:\2, \3:\4}/g" "$java2dartFile"
  sed -i "s/{}{{\(.*\),\(.*\)}}/{\1:\2}/g" "$java2dartFile"
  echo "==>String[][]替换为Map"
  echo "---------------------------------------------"

  #分号增加准确性
  #echo 'new String[]{"AUTH_IP","SH_IP","SZ_IP","PB_IP","BJ_IP","HKD1_IP"};' | sed "s/new String\[\]{\(.*\)}/[\1]/g"
  #echo 'new String[]{plateIndexItem.mainforceMoneyInflow};' | sed "s/new String\[\]{\(.*\)}/[\1]/g"
  #echo 'newShareList.setSubTitles(new String[]{"股票", "发行价", "市盈率", "中签公布"});' | sed "s/new String\[\]{\(.*\)}/[\1]/g"
  sed -i "s/new String\[\]{\(.*\)}/[\1]/g" "$java2dartFile"
  #echo 'new String[]{};' | sed 's/new String\[\]{};/\[\];/g'
  sed -i "s/new String\[\]{}/\[\]/g" "$java2dartFile"
  #echo 'new String[jsonArray.length()];' | sed 's/new String\[.*\];/[];/g'
  sed -i "s/new String\[.*\];/[];/g" "$java2dartFile"
  sed -i "s/String\[\]/List<String>/g" "$java2dartFile"
  echo "==>String[]替换为List<String>"
  echo "---------------------------------------------"

  #echo 'SparseArray<String[]> apis' | sed 's/SparseArray<\(.*\)> /Map<int, \1> /g'
  sed -i "s/new SparseArray<>();/{};/g" "$java2dartFile"
  sed -i "s/SparseArray<\(.*\)> /Map<int, \1> /g" "$java2dartFile"
  sed -i "s/\bSparseArray\b/Map<int, dynamic>/g" "$java2dartFile"
  sed -i "s/new SparseIntArray();/{};/g" "$java2dartFile"
  sed -i "s/SparseIntArray<\(.*\)> /Map<int, int> /g" "$java2dartFile"
  sed -i "s/\bSparseIntArray\b/Map<int, int>/g" "$java2dartFile"

  #echo 'ConcurrentHashMap<String, String> referenceMap' | sed "s/ConcurrentHashMap<\(.*\)> /Map<\1> /g"
  sed -i "s/new ConcurrentHashMap();/{};/g" "$java2dartFile"
  sed -i "s/new ConcurrentHashMap<.*>();/{};/g" "$java2dartFile"
  sed -i "s/ConcurrentHashMap<\(.*\)> /Map<\1> /g" "$java2dartFile"
  sed -i "s/\bConcurrentHashMap\b/Map/g" "$java2dartFile"
  sed -i "s/ConcurrentMap<\(.*\)> /Map<\1> /g" "$java2dartFile"
  sed -i "s/\bConcurrentMap\b/Map/g" "$java2dartFile"

  # Dart内支持LinkedHashMap及LinkedHashSet，但不支持Hashtable
  #HashMap<String, String> root = new HashMap<>(httpData.headers); 暂时排除带内容初始化
  #HashMap<String, String> root = new HashMap<>(10); 暂时排除带内容初始化
  sed -i "s/new HashMap<>();/{};/g" "$java2dartFile"
  sed -i "s/new HashMap();/{};/g" "$java2dartFile"
  sed -i "s/\bHashMap\b/Map/g" "$java2dartFile"
  sed -i "s/new HashSet<>();/{};/g" "$java2dartFile"
  sed -i "s/\bHashSet\b/Set/g" "$java2dartFile"
  #echo 'Hashtable<String, Object> table2 = new Hashtable<>();' | sed "s/new Hashtable<>();/{};/g" | sed "s/Hashtable<\(.*\)> /Map<\1> /g"
  sed -i "s/new Hashtable();/{};/g" "$java2dartFile"
  sed -i "s/new Hashtable<>();/{};/g" "$java2dartFile"
  sed -i "s/Hashtable<\(.*\)> /Map<\1> /g" "$java2dartFile"
  sed -i "s/\bHashtable\b/Map/g" "$java2dartFile"
  #LinkedHashSet<Integer> linkedHashSet = new LinkedHashSet<>();
  sed -i "s/new LinkedHashSet<>()/{}/g" "$java2dartFile"

  sed -i "s/new ArrayList();/\[\];/g" "$java2dartFile"
  sed -i "s/new ArrayList<>();/\[\];/g" "$java2dartFile"
  #echo 'CopyOnWriteArrayList<OHLCItem> ' | sed "s/CopyOnWriteArrayList<\(.*\)> /List<\1> /g"
  sed -i "s/new CopyOnWriteArrayList<>();/[];/g" "$java2dartFile"
  sed -i "s/CopyOnWriteArrayList<\(.*\)> /List<\1> /g" "$java2dartFile"
  sed -i "s/CopyOnWriteArrayList /List /g" "$java2dartFile"
  sed -i "s/ArrayList<\(.*\)> /List<\1> /g" "$java2dartFile"
  sed -i "s/\bArrayList\b/List/g" "$java2dartFile"
  echo "==>/Hashtable/ConcurrentMap/SparseArray/ArrayList替换为Map/List"
  echo "---------------------------------------------"

  echo 'for (Map.Entry<String, BaseQuoteItem> entry : mQuoteItems.entrySet()) {' | sed "s/.entrySet()/.entries/g" | sed "s/Map.Entry</MapEntry</g"
  sed -i "s/Map.Entry</MapEntry</g" "$java2dartFile"
  sed -i "s/.entrySet()/.entries/g" "$java2dartFile"
  sed -i "s/.getKey()/.key/g" "$java2dartFile"
  sed -i "s/.getValue()/.value/g" "$java2dartFile"
  echo "==>Map.Entry替换为entrySet"
  echo "---------------------------------------------"

  echo 'builder.append(" stockType = '").append(str).append("' or ");' | sed "s/.append(/..write(/g"
  sed -i "s/\bStringBuilder\b/StringBuffer/g" "$java2dartFile"
  sed -i "s/.append(/..write(/g" "$java2dartFile"
  echo "==>StringBuilder替换为StringBuffer"
  echo "---------------------------------------------"

  sed -i "s/\.isEmpty()/.isEmpty/g" "$java2dartFile"
  sed -i "s/\.size()/.length/g" "$java2dartFile"
  sed -i "s/\.length()/.length/g" "$java2dartFile"
  echo "==>size()/length()/isEmpty()替换为length/isEmpty"
  echo "---------------------------------------------"

  sed -i "s/System.currentTimeMillis()/DateTime.now().millisecond/g" "$java2dartFile"
  echo "==>System.currentTimeMillis()替换为DateTime.now().millisecond"
  echo "---------------------------------------------"

  #echo 'SimpleDateFormat sdf = new SimpleDateFormat("HHmm");' | sed "s/new SimpleDateFormat(\"HHmm\")/DateFormat(\"hhmm\")/g" | sed 's/\bSimpleDateFormat\b/DateFormat/g'
  #echo 'SimpleDateFormat format = new SimpleDateFormat("HH:mm");' | sed "s/new SimpleDateFormat(\"HH:mm\")/DateFormat(\"hhmm\")/g" | sed 's/\bSimpleDateFormat\b/DateFormat/g'
  sed -i "s/new SimpleDateFormat(\"HHmm\")/DateFormat(\"hhmm\")/g" "$java2dartFile"
  sed -i "s/new SimpleDateFormat(\"HH:mm\")/DateFormat(\"hhmm\")/g" "$java2dartFile"
  sed -i "s/\bSimpleDateFormat\b/DateFormat/g" "$java2dartFile"

  #Date zeroTime = new Date();
  #echo 'new Date();' | sed 's/new Date();/DateTime.now();/g'
  #echo 'Date zeroTime' | sed 's/\bDate \b/DateTime /g'
  sed -i 's/new Date();/DateTime.now();/g' "$java2dartFile"
  sed -i 's/\bDate \b/DateTime /g' "$java2dartFile"

  echo "==>SimpleDateFormat替换为DateFormat"
  echo "---------------------------------------------"

  ## .put() samples
  #echo '.put(MarketSiteType.TCPSZ,  new String[]{});' | sed 's/\.put(\(.*\), */\[\1\]=/g'  | sed 's/);/;/g'
  #echo '.put(MarketSiteType.TCPSZ,  new String[]{});' | sed 's/.\put(\(.*, *.*);\)/\[\1/g' | sed 's/, */\] = /g' | sed 's/);/;/g'
  #echo '.put(MarketSiteType.TCPSZ,  new String[]{});' | sed 's/\.put(\(.*\), *\(.*\));/\[\1\]=\2;/g'
  #此处sed内第一个.需要转义，否则会把不带.的也匹配上
  #echo 'put(F10ParamKeys.F10API, api);' | sed "s/\.put(\(.*\), *\(.*\));/\[\1\]=\2;/g"
  sed -i 's/\.put(\(.*\), *\(.*\));/\[\1\]=\2;/g' "$java2dartFile"
  echo "==>.put()替换为[]"
  echo "---------------------------------------------"

  #quoteItem.buyPrices.add(0, data);
  #echo '.add(0, data);' | sed 's/\.add(\(.*\), *\(.*\));/\[\1\]=\2;/g'
  sed -i 's/\.add(\(.*\), *\(.*\));/\[\1\]=\2;/g' "$java2dartFile"
  echo "==>.add()替换为[]"
  echo "---------------------------------------------"


  #echo 'map.get("PUBDATE") == null ? "" : (String) map.get("PUBDATE")' | sed "s/.get(\(.*\))\(.*).*\)\.get(\(.*\))/\[\1\]\2\[\3\]/g"
  sed -i "s/\.get(\(.*\))\(.*).*\)\.get(\(.*\))/\[\1\]\2\[\3\]/g" "$java2dartFile"
  #echo 'map.get("PUBDATE") == null ? "" : map.get("PUBDATE")' | sed 's/\.get(\(.*\))\(.*\)\.get(\(.*\))/\[\1\]\2\[\3\]/g'
  sed -i "s/\.get(\(.*\))\(.*\)\.get(\(.*\))/\[\1\]\2\[\3\]/g" "$java2dartFile"
  #echo "FormatUtility.formatStringToInt(dataList.get(i).datetime.substring(8, 12));" | sed "s/\.get(\(.*\))\(.*))\)/\[\1\]\2/g"
  sed -i "s/\.get(\(.*\))\(.*))\)/\[\1\]\2/g" "$java2dartFile"
  #echo 'FormatUtility.formatStringToFloat(chartItemsList.get(i).tradeVolume);' | sed "s/\.get(\(.*\))\./\[\1\]./g"
  sed -i "s/\.get(\(.*\))\./\[\1\]./g" "$java2dartFile"
  #echo "dataList.get(i).datetime.substring(8, 12);" | sed "s/\.get(\(.*\))\(.*)\)/\[\1\]\2/g"
  sed -i "s/\.get(\(.*\))\(.*)\)/\[\1\]\2/g" "$java2dartFile"
  sed -i "s/\.get(\(.*\)))))/\[\1\])))/g" "$java2dartFile"
  sed -i "s/\.get(\(.*\))))/\[\1\]))/g" "$java2dartFile"
  #echo "items.add(dataList.get(i));" | sed "s/\.get(\(.*\)))/\[\1\])/g"
  sed -i "s/\.get(\(.*\)))/\[\1\])/g" "$java2dartFile"
  #echo "TradeDate tradeDate = allList.get(i);" | sed "s/\.get(\(.*\))/\[\1\]/g"
  #echo "dataList.get(dataList.size() - 1).reference_price;" | sed "s/\.get(\(.*\))/\[\1\]/g"
  #echo 'mID = (String) response.info.get("TRADINGCODE");' | sed "s/\.get(\(.*\))/\[\1\]/g"
  sed -i "s/\.get(\(.*\))/\[\1\]/g" "$java2dartFile"
  echo "==>.get()替换为[]"
  echo "---------------------------------------------"

  ##=============================
  # Android Sdk 自带的 org.json 相关替换
  ##=============================
  # echo 'JSONObject jsonObject = new JSONObject(str)' | sed "s/new JSONObject(\(.*\))/OptionMap()..addAll(jsonDecode(\1))/g" |  sed "s/\bJSONObject\b/OptionMap<dynamic, dynamic>/g"
  sed -i "s/new JSONObject(\(.*\))/OptionMap()..addAll(jsonDecode(\1))/g" "$java2dartFile"
  sed -i "s/\bJSONObject\b/OptionMap<dynamic, dynamic>/g" "$java2dartFile"

  # echo 'JSONArray root = new JSONArray(data);' | sed "s/new JSONArray(\(.*\))/OptionList()..addAll(jsonDecode(\1))/g" |  sed "s/\bJSONArray\b/OptionList<dynamic>/g"
  sed -i "s/new JSONArray(\(.*\))/OptionList()..addAll(jsonDecode(\1))/g" "$java2dartFile"
  sed -i "s/\bJSONArray\b/OptionList<dynamic>/g" "$java2dartFile"

  echo "==>org.json.JSONObject/JSONArray替换为Map/List"
  echo "---------------------------------------------"

  #echo 'for (String key : columns)' | sed 's/\(for *(.*\):\(.*)\)/\1 in \2/g'
  #echo 'for (Map.Entry<KLineRequestParam, OHLCResponse> entry : KlineResponses.entrySet())' | sed 's/\(for *(.*\):\(.*)\)/\1 in \2/g'
  #echo 'for(int j = 0, i = quoteItem.buyVolumes.size() - 1, len = (quoteItem.buyVolumes.size() >= rowCount ? rowCount : quoteItem.buyVolumes.size()) ; j < len ; j++, i--)' | sed 's/\(for *(.*?\{0\}.*\):\{1\}\(.*)\)/\1 in \2/g'
  sed -i "s/\(for *(.*\):\(.*)\)/\1 in \2/g" "$java2dartFile"
  echo "==>for循环内:替换为in"
  echo "---------------------------------------------"

  #echo 'boolean b = MarketType.FE.equals(quoteItem.market)' | sed "s/\(.*\).equals(\(.*\))/\1 == \2/g"
  #echo 'if (MarketType.FE.equals(quoteItem.market))' | sed "s/\(.*\).equals(\(.*\)))/\1 == \2)/g"
  #echo 'if (MarketType.FE.equals(market) || MarketType.GI.equals(market))' | sed "s/\(.*\).equals(\(.*\))\(.*\).equals(\(.*\)))/\1 == \2\3 == \4)/g"
  #echo 'if (F10ParamKeys.SRC.equals(key) || F10ParamKeys.VERSION.equals(key) || F10ParamKeys.F10API.equals(key))' | sed "s/\(.*\).equals(\(.*\))\(.*\).equals(\(.*\))\(.*\).equals(\(.*\)))/\1 == \2\3 == \4\5 == \6)/g"
  sed -i "s/\(.*\).equals(\(.*\))\(.*\).equals(\(.*\))\(.*\).equals(\(.*\)))/\1 == \2\3 == \4\5 == \6)/g" "$java2dartFile"
  sed -i "s/\(.*\).equals(\(.*\))\(.*\).equals(\(.*\)))/\1 == \2\3 == \4)/g" "$java2dartFile"
  #echo 'if (sortType.equalsIgnoreCase("") || sortType == null)' | sed "s/\(.*\).equalsIgnoreCase(\(.*\))\(.*\))/\1 == \2\3)/g"
  sed -i "s/\(.*\).equalsIgnoreCase(\(.*\))\(.*\))/\1 == \2\3)/g" "$java2dartFile"
  sed -i "s/\(.*\).equalsIgnoreCase(\(.*\)))/\1 == \2)/g" "$java2dartFile"
  sed -i "s/\(.*\).equals(\(.*\)))/\1 == \2)/g" "$java2dartFile"
  sed -i "s/\(.*\).equals(\(.*\))/\1 == \2/g" "$java2dartFile"
  echo "==>equal替换为="
  echo "---------------------------------------------"


  #echo 'String.replace("-", "")' | sed "s/\.replace(/.replaceAll(/g"
  sed -i "s/\.replace(/.replaceAll(/g" "$java2dartFile"
  #echo 'throws JSONException {' | sed 's/throws .*Exception//g'
  sed -i "s/throws .*Exception//g" "$java2dartFile"
  #echo 'catch (Exception e)' | sed "s/catch *(.*Exception \(.*\))/catch (\1)/g"
  #echo 'catch (JSONException exception)' | sed "s/catch *(.*Exception \(.*\))/catch (\1)/g"
  sed -i "s/catch *(.*Exception \(.*\))/catch (\1)/g" "$java2dartFile"


  #特殊情况，精准匹配
  #echo 'FormatUtility.formatStringToDouble' | sed "s/\bDouble\b/double/g"
  #echo 'int integerWidth' | sed "s/\bInteger\b/int/g"
  #echo 'LinkedHashMap<String, Integer>' | sed "s/\bInteger\b/int/g"
  #echo 'boolean b' | sed 's/\bboolean\b/bool/g'
  sed -i "s/\bboolean\b/bool/g" "$java2dartFile"
  sed -i "s/\bfloat\b/double/g" "$java2dartFile"
  sed -i "s/\blong\b/int/g" "$java2dartFile"
  sed -i "s/\bshort\b/int/g" "$java2dartFile"
  sed -i "s/\bInteger\b/int/g" "$java2dartFile"
  sed -i "s/\bLong\b/int/g" "$java2dartFile"
  sed -i "s/\bDouble\b/double/g" "$java2dartFile"
  sed -i "s/\bFloat/double/g" "$java2dartFile"
  sed -i "s/\bBoolean\b/bool/g" "$java2dartFile"
  echo "==>boolean/float/long/short替换bool/double/int"
  echo "---------------------------------------------"

  #echo 'if (value instanceof String)' | sed "s/\binstanceof\b/is/g"
  sed -i "s/\binstanceof\b/is/g" "$java2dartFile"
  echo "==>instanceof替换为is"
  echo "---------------------------------------------"

  #echo 'paint = new Paint();' | sed 's/\bnew\b//g'
  sed -i "s/ implements Parcelable//g" "$java2dartFile"
  sed -i "s/\bnew\b//g" "$java2dartFile"
  echo "==>删除new关键字，删除Parcelable"
  echo "---------------------------------------------"

  ##=============================
  #SDK内一些个性化的替换，非通用语法替换
  ##=============================
  # sed -i "s/ extends SseSerializable//g" "$java2dartFile"
  # sed -i "s/ implements SseSerializable//g" "$java2dartFile"


   echo "完成对文件 $java2dartFile 的替换"
   echo "============================================="
}


main() {
   if [ -d "$file" ]; then
      #echo "$file is a directory "
      echo "开始对 $file 文件夹下的java文件进行处理"
      files=$(ls $file/*.${oldsuffix})
      if [ ! -n "$file" ]; then  
         echo "该 $file 文件夹下未找到Java文件, 已结束"
      else
         for filename in $files
         do
            java2dart $filename
         done
      fi    
   elif [ -f "$file" ]; then
      #echo "$file is a file"
      java2dart $file
   fi
}

main "$@"