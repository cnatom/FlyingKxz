
import 'package:flying_kxz/Model/video__data.dart';

/// 数据清洗模块
class CumtFormat{
  //校园卡流水
  static Map<String,dynamic> parseBalanceHis(Map<String,dynamic> data){
    var l1 = [];
    for(var a in data['data']){
      l1.add({
        "cardNumber": a['XGH'],
        "Type": a['JYLX'],
        "Location": a['ZDMC'],
        "name": a['SHMC'],
        "costMoney": a['JYE'],
        "balance": a['YE'],
        "time": a['JYSJ']
      });
    }
    return {
      'data':l1
    };
  }
  static Map<String,dynamic> parseVideo(){
    Map<String,dynamic> data = {
      "iRecordCount": 35,
      "iPageCount": 7,
      "iCurrentPageIndex": 1,
      "lst_DataSource": [
        {
          "Course": {
            "SeatNum": 0,
            "FileStoreUrl": "http://121.248.108.57:9091",
            "ThumbnailPath": "/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg",
            "SegmentList": null,
            "ID": "c3784416-8e50-499a-94cd-0758c7ebb8ee",
            "CourseID": "3879DA27-2109-4503-BF7D-C342F4AD9612",
            "CourseName": "马克思主义基本原理",
            "TeacherName": null,
            "TeacherID": "EED022D6-C56D-471C-BB21-FEEABE57D5D0",
            "UserName": "罗肖泉",
            "RecommendName": null,
            "RoomID": "J2-A201",
            "CourseDate": "2021-06-03",
            "ShowCourseDate": "2021-06-03",
            "SegmentID": null,
            "Segment": 0,
            "SegmentLength": 0,
            "DepartmentID": null,
            "SchoolCourseID": null,
            "ClassName": null,
            "DeptName": null,
            "CollegeID": null,
            "RoomName": null,
            "StartTime": "0001-01-01",
            "EndTime": "0001-01-01",
            "StartTimeW": "0001-01-01",
            "EndTimeW": "0001-01-01",
            "CollegeName": null,
            "Description": null,
            "WeekNum": 0,
            "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
            "Term": 2,
            "ShowTerm": "第二学期",
            "SchoolYear": "2020-2021",
            "Score": 0,
            "IsSeason": 0,
            "Status": 0,
            "ShowStatus": "待审核",
            "ApplyTime": "0001-01-01",
            "Remark": null,
            "ComPliedCount": 0,
            "CourseStartTime": null,
            "ClassRoomType": null,
            "CameraName": null,
            "GroupName": null,
            "compliedlist": null,
            "MissionType": 0,
            "IsSource": 0,
            "IsEvaluation": 0,
            "EvaluationCount": 0,
            "Appraiser": null
          },
          "CourseDateList": [
            {
              "Date": "2021-06-03",
              "Id": "c3784416-8e50-499a-94cd-0758c7ebb8ee",
              "CourseID": "3879DA27-2109-4503-BF7D-C342F4AD9612",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-31",
              "Id": "7f05b9b5-24b6-445c-a441-8a83ea03f245",
              "CourseID": "E8073A6E-4C42-4EA7-99F8-90A59E5B43B1",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.56:9091",
              "ThumbnailPath": "/20210531/06C7D02B-9071-4405-A563-1F70B85FA3C0_J2-A201/C756BE10-C249-4B9C-AA82-F59B2177B88D/C756BE10-C249-4B9C-AA82-F59B2177B88D-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-28",
              "Id": "4afecfd3-480c-461d-99b3-df8d4ee105a1",
              "CourseID": "0DA656CF-9F40-4EA3-BB4A-4F41CCE7E13F",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.54:9091",
              "ThumbnailPath": "/20210528/5784B570-CE97-482F-8E92-A715C59BC6D5_J2-A201/C2481947-0757-4297-AB23-18D3C185397B/C2481947-0757-4297-AB23-18D3C185397B-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-27",
              "Id": "3d4e835d-059a-4c35-833a-93f04ae1aa77",
              "CourseID": "7713697B-DD0A-4F17-ABC0-B30E7B9756D0",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.49:9091",
              "ThumbnailPath": "/20210527/55C3B173-B403-4BAA-8FFA-7CC7CF77742E_J2-A201/4A1A43D8-BE7F-45D5-83F5-83122280CA4F/4A1A43D8-BE7F-45D5-83F5-83122280CA4F-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-24",
              "Id": "94060433-76fc-42b8-ad5d-e8078b9158f7",
              "CourseID": "8383B55F-DF0A-4E9B-A4A3-06F74A302CF0",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.55:9091",
              "ThumbnailPath": "/20210524/FF4E31F8-BFA1-41A1-80D1-31601E990FAF_J2-A201/BE7A9BB3-DA55-4113-A778-56BD948C6F9B/BE7A9BB3-DA55-4113-A778-56BD948C6F9B-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-21",
              "Id": "d9896a4c-1e19-4aff-b5c7-ca8358707a62",
              "CourseID": "46A39AD7-3B1E-4BB1-B1C9-F636BB1C8433",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.47:9091",
              "ThumbnailPath": "/20210521/7C8F8F39-9F52-43E5-BFE8-E0740D6B8DBA_J2-A201/F159CE04-18B5-4EC3-B654-063A4F3C2726/F159CE04-18B5-4EC3-B654-063A4F3C2726-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-20",
              "Id": "b8e0b694-2864-4f96-b82c-8e1422274764",
              "CourseID": "ADA1BDE4-035D-4B38-B53E-A594E5600FB5",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.56:9091",
              "ThumbnailPath": "/20210520/0414140E-BCBC-49C7-B373-43DA54852F5E_J2-A201/BBCC05CA-8055-4168-A3CE-29B8E1CA2E7C/BBCC05CA-8055-4168-A3CE-29B8E1CA2E7C-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-17",
              "Id": "4816e14d-3389-4794-9622-a13542b9b98c",
              "CourseID": "0DDE6F1C-8FA9-45D8-AA01-7575B145A144",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210517/0E33BDE6-85B3-449F-9AC3-2EC144310ECA_J2-A201/93804279-286F-48A1-A05A-8F0F67BCAB05/93804279-286F-48A1-A05A-8F0F67BCAB05-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-14",
              "Id": "dfa448e7-1437-459f-8c97-3dfd5bf5728a",
              "CourseID": "CACF9195-EC38-425D-BDB0-062B0CDFD49C",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.51:9091",
              "ThumbnailPath": "/20210514/91AE435F-CADF-4F6B-AB1F-1A62B904C736_J2-A201/D6714BFB-69B3-46C7-966C-6B1158796AC7/D6714BFB-69B3-46C7-966C-6B1158796AC7-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-13",
              "Id": "f7a60a23-66d2-4727-a264-acaee2d73f55",
              "CourseID": "FFE0FF7A-6A51-4F38-B8DC-176168416D5F",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.47:9091",
              "ThumbnailPath": "/20210513/F3AE9B9B-F861-488C-BC30-92360F6E53DF_J2-A201/91C34967-C79A-4EEF-8792-829DFE6FC442/91C34967-C79A-4EEF-8792-829DFE6FC442-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-10",
              "Id": "b9db7dc5-ef7d-492e-87a6-a0a32e747624",
              "CourseID": "4F1B27C1-ED8E-42B2-AE56-79C1BCCC86E2",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.54:9091",
              "ThumbnailPath": "/20210510/E9DCF47E-9FA8-4FD7-B5F1-F0A58AD0B9B2_J2-A201/E269FC01-3C2A-4C96-97F2-986649F2508B/E269FC01-3C2A-4C96-97F2-986649F2508B-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-07",
              "Id": "ff11b438-5439-43f5-b9ad-7c1434d12702",
              "CourseID": "CC6811E7-8135-4119-9AEC-1FDEB20D3300",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.44:9091",
              "ThumbnailPath": "/20210507/CF893BD9-8197-4C96-AD80-775F893ED1D8_J2-A201/F58E9756-F29F-4ECF-A2ED-32000A629C1C/F58E9756-F29F-4ECF-A2ED-32000A629C1C-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-06",
              "Id": "91cfd7cc-1dc5-4215-ae10-b754b20d64cd",
              "CourseID": "F07BA7B6-32C9-4CF7-8AE6-2C6081292037",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.55:9091",
              "ThumbnailPath": "/20210506/3CAC973C-4560-47B5-95C8-BED192CA37D6_J2-A201/6CAC7D82-3B21-4C52-8AF7-18EDD60959BB/6CAC7D82-3B21-4C52-8AF7-18EDD60959BB-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-04-30",
              "Id": "3222cb8d-dd4d-4504-b1b0-6c9ee07becce",
              "CourseID": "D5574B86-3B06-4528-9A4A-1CD004F0F513",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.53:9091",
              "ThumbnailPath": "/20210430/0880B6B3-CC0B-4FEA-B43A-71C3798026EA_J2-A201/A298FDE1-E0ED-45B6-BC2B-3CAFB70B73BD/A298FDE1-E0ED-45B6-BC2B-3CAFB70B73BD-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-04-29",
              "Id": "7476d64e-b9fb-4978-a322-40952ca65115",
              "CourseID": "65762EC6-1C7E-487D-8083-0C6C02760FB3",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210429/0C3EDEF2-C4A5-4E66-88EA-A9BF6B3C6269_J2-A201/FBECD392-BF5C-42A9-B127-A9ED4567E57C/FBECD392-BF5C-42A9-B127-A9ED4567E57C-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-04-26",
              "Id": "5bc71fbf-0a0a-4355-a4cf-764568bf6fc9",
              "CourseID": "0EF8CC64-CF15-4716-9EDC-480AFADEFCFB",
              "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
              "RoomId": "J2-A201",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.45:9091",
              "ThumbnailPath": "/20210426/69CA8544-F1C6-4442-A489-645CC1EDDAA3_J2-A201/9AB9E179-A69F-46B3-90A9-B53EF0629960/9AB9E179-A69F-46B3-90A9-B53EF0629960-1.jpg",
              "ComPliedCount": 0
            }
          ]
        },
        {
          "Course": {
            "SeatNum": 0,
            "FileStoreUrl": "http://121.248.108.48:9091",
            "ThumbnailPath": "/20210603/0E42E0F4-94E9-48C5-A612-4E990E7EE10F_J4-B405/ADB75A0F-9286-4238-8904-43FA7A419DBB/ADB75A0F-9286-4238-8904-43FA7A419DBB-1.jpg",
            "SegmentList": null,
            "ID": "cbba2747-961e-48ff-b436-10aa587461f7",
            "CourseID": "2624D4AF-48BC-4DA6-8D29-453054EE3C8C",
            "CourseName": "概率论与数理统计(16版，",
            "TeacherName": null,
            "TeacherID": "22BB5861-3392-4241-B75E-603D16D12EE5",
            "UserName": "芮文娟",
            "RecommendName": null,
            "RoomID": "J4-B405",
            "CourseDate": "2021-06-03",
            "ShowCourseDate": "2021-06-03",
            "SegmentID": null,
            "Segment": 0,
            "SegmentLength": 0,
            "DepartmentID": null,
            "SchoolCourseID": null,
            "ClassName": null,
            "DeptName": null,
            "CollegeID": null,
            "RoomName": null,
            "StartTime": "0001-01-01",
            "EndTime": "0001-01-01",
            "StartTimeW": "0001-01-01",
            "EndTimeW": "0001-01-01",
            "CollegeName": null,
            "Description": null,
            "WeekNum": 0,
            "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
            "Term": 2,
            "ShowTerm": "第二学期",
            "SchoolYear": "2020-2021",
            "Score": 0,
            "IsSeason": 0,
            "Status": 0,
            "ShowStatus": "待审核",
            "ApplyTime": "0001-01-01",
            "Remark": null,
            "ComPliedCount": 0,
            "CourseStartTime": null,
            "ClassRoomType": null,
            "CameraName": null,
            "GroupName": null,
            "compliedlist": null,
            "MissionType": 0,
            "IsSource": 0,
            "IsEvaluation": 0,
            "EvaluationCount": 0,
            "Appraiser": null
          },
          "CourseDateList": [
            {
              "Date": "2021-06-03",
              "Id": "cbba2747-961e-48ff-b436-10aa587461f7",
              "CourseID": "2624D4AF-48BC-4DA6-8D29-453054EE3C8C",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.48:9091",
              "ThumbnailPath": "/20210603/0E42E0F4-94E9-48C5-A612-4E990E7EE10F_J4-B405/ADB75A0F-9286-4238-8904-43FA7A419DBB/ADB75A0F-9286-4238-8904-43FA7A419DBB-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-28",
              "Id": "b2eedb55-9eae-4038-81c5-4bcfaa6c0046",
              "CourseID": "DFC6FF0A-DFCD-4C95-A566-A1761B599228",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.44:9091",
              "ThumbnailPath": "/20210528/68C651DD-2C61-4D50-B0F6-53227F503A9C_J4-B405/1E883142-48B5-4281-8EBE-00EBDE4902CE/1E883142-48B5-4281-8EBE-00EBDE4902CE-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-27",
              "Id": "491a3208-1ef8-4a93-9b55-daec5099d5fc",
              "CourseID": "2A082B26-36E3-45CD-95E0-8ADF4DDD4002",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.44:9091",
              "ThumbnailPath": "/20210527/C9555DEC-2ED3-4D35-A446-F38050635E8C_J4-B405/EA557468-36D1-4758-ACA4-F0AF8E213964/EA557468-36D1-4758-ACA4-F0AF8E213964-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-25",
              "Id": "8d69a01c-ad1f-4b04-8dca-2c5beb5f379b",
              "CourseID": "8BC80F46-0419-4BD3-A083-615E1DA2B891",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.48:9091",
              "ThumbnailPath": "/20210525/44AE17B6-C157-4FDF-A765-5AC5047C4973_J4-B405/94F64433-FC4F-49A4-99FB-8A338D3414FF/94F64433-FC4F-49A4-99FB-8A338D3414FF-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-21",
              "Id": "a4fc58a3-3e2d-4ec1-9959-c04a5214e288",
              "CourseID": "DBD3DD20-F2FD-4C59-ABDC-4E1E8BB098E0",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.47:9091",
              "ThumbnailPath": "/20210521/8BAC6EC2-6763-4A66-9605-DEACB8E67A46_J4-B405/1E8F0559-9056-4E35-B60F-4A410E2060FD/1E8F0559-9056-4E35-B60F-4A410E2060FD-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-20",
              "Id": "d0a06acd-b724-4a92-b13f-50ab1f3b9d67",
              "CourseID": "C4D6EE42-D3A5-4C2A-8945-8610711B5AC4",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210520/69D50F0B-A35D-4A8A-9D16-C256B2F07C21_J4-B405/D68A98E8-1A1F-4314-86A9-F0D05719CF76/D68A98E8-1A1F-4314-86A9-F0D05719CF76-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-18",
              "Id": "64adc75d-b43f-4a19-8d4b-8c2236b40c21",
              "CourseID": "10F7DA38-802A-4506-B8A9-E5C0E73A72FA",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210518/4A25BD2C-6660-42FA-A0C7-25F4C74C7BD4_J4-B405/EC0398F0-1235-45D2-B898-AC62379790E7/EC0398F0-1235-45D2-B898-AC62379790E7-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-14",
              "Id": "fdd7947e-e0aa-438a-a4f4-d3680be97d55",
              "CourseID": "A863A92C-9604-4D06-9837-A183749E2E28",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.49:9091",
              "ThumbnailPath": "/20210514/1797AA2B-EDB9-4BB7-938A-00842FC9B8D2_J4-B405/5F6B504D-8457-4710-97ED-EC9E8CFB0A39/5F6B504D-8457-4710-97ED-EC9E8CFB0A39-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-11",
              "Id": "89730fc2-cfab-4aa1-a4f2-6060ba8a6c55",
              "CourseID": "7B42869B-3A41-475E-B3E5-A7D45798F76D",
              "CourseCode": "AFC2A5F1-8828-4EFB-8D70-47BD73117013",
              "RoomId": "J4-B405",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.52:9091",
              "ThumbnailPath": "/20210511/3FC8B12A-1388-4B2B-8361-3E555ADDEF62_J4-B405/68812B1A-FCBB-440F-843D-7A0A355AC709/68812B1A-FCBB-440F-843D-7A0A355AC709-1.jpg",
              "ComPliedCount": 0
            }
          ]
        },
        {
          "Course": {
            "SeatNum": 0,
            "FileStoreUrl": "http://121.248.108.56:9091",
            "ThumbnailPath": "/20210603/3F3BD88A-8AD7-42F0-A4A5-A41C730BC2D0_J2-B102/889EB9B7-7458-46A7-8341-D6B0BF8DD5A7/889EB9B7-7458-46A7-8341-D6B0BF8DD5A7-1.jpg",
            "SegmentList": null,
            "ID": "d9f1f570-e906-42e5-b308-83673d51b693",
            "CourseID": "A0AA56D4-9DF9-4320-9A4C-EA8F8FFB60AC",
            "CourseName": "跟着电影学沟通",
            "TeacherName": null,
            "TeacherID": "019E70E7-0E42-4903-B165-FC8B4BD68780",
            "UserName": "杨雷",
            "RecommendName": null,
            "RoomID": "J2-B102",
            "CourseDate": "2021-06-03",
            "ShowCourseDate": "2021-06-03",
            "SegmentID": null,
            "Segment": 0,
            "SegmentLength": 0,
            "DepartmentID": null,
            "SchoolCourseID": null,
            "ClassName": null,
            "DeptName": null,
            "CollegeID": null,
            "RoomName": null,
            "StartTime": "0001-01-01",
            "EndTime": "0001-01-01",
            "StartTimeW": "0001-01-01",
            "EndTimeW": "0001-01-01",
            "CollegeName": null,
            "Description": null,
            "WeekNum": 0,
            "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
            "Term": 2,
            "ShowTerm": "第二学期",
            "SchoolYear": "2020-2021",
            "Score": 0,
            "IsSeason": 0,
            "Status": 0,
            "ShowStatus": "待审核",
            "ApplyTime": "0001-01-01",
            "Remark": null,
            "ComPliedCount": 0,
            "CourseStartTime": null,
            "ClassRoomType": null,
            "CameraName": null,
            "GroupName": null,
            "compliedlist": null,
            "MissionType": 0,
            "IsSource": 0,
            "IsEvaluation": 0,
            "EvaluationCount": 0,
            "Appraiser": null
          },
          "CourseDateList": [
            {
              "Date": "2021-06-03",
              "Id": "d9f1f570-e906-42e5-b308-83673d51b693",
              "CourseID": "A0AA56D4-9DF9-4320-9A4C-EA8F8FFB60AC",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.56:9091",
              "ThumbnailPath": "/20210603/3F3BD88A-8AD7-42F0-A4A5-A41C730BC2D0_J2-B102/889EB9B7-7458-46A7-8341-D6B0BF8DD5A7/889EB9B7-7458-46A7-8341-D6B0BF8DD5A7-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-06-01",
              "Id": "ec1794cc-39fd-415f-8dc8-c0b708070a7c",
              "CourseID": "E301323A-33F2-430E-A2EA-0C25A412307A",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.56:9091",
              "ThumbnailPath": "/20210601/564AF5D3-903F-45C3-AD9F-E4448FE66D9D_J2-B102/4AF3BB92-51CB-4A19-B995-BF08051BDDE2/4AF3BB92-51CB-4A19-B995-BF08051BDDE2-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-27",
              "Id": "8eb0258a-41df-4f93-bd60-3539bcdf7a19",
              "CourseID": "5F11BB00-8EFB-4E43-AD47-34007E492B05",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.56:9091",
              "ThumbnailPath": "/20210527/7A4247D3-9845-41B3-9FAE-CB7B8B211982_J2-B102/54EE3027-72CD-4817-BF0E-24ACD7FB63E3/54EE3027-72CD-4817-BF0E-24ACD7FB63E3-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-25",
              "Id": "3bfc3ea1-d599-4b66-8c34-fcd51b663aa8",
              "CourseID": "545F92AC-61B6-4A6B-9A4F-6DDD53689B3C",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.51:9091",
              "ThumbnailPath": "/20210525/6BE2E51F-D69B-4690-8108-F7E9EC3C6622_J2-B102/5AAEF762-A003-401C-8CB9-44543B21A64D/5AAEF762-A003-401C-8CB9-44543B21A64D-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-20",
              "Id": "ccf03398-b086-41c3-9cd3-93f8106f9312",
              "CourseID": "303472F2-BD7B-4457-98A1-0F02D025765A",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210520/18684B9D-8D19-4E72-99C1-ED6C0A9FAA9B_J2-B102/26DF3C7C-88AF-4224-B9FD-16D6E5DD89A5/26DF3C7C-88AF-4224-B9FD-16D6E5DD89A5-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-18",
              "Id": "cbc3b6ea-d063-47a4-bca5-33a4883e7681",
              "CourseID": "70C02169-6629-4160-945B-2508E186E171",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.52:9091",
              "ThumbnailPath": "/20210518/0635B081-5591-41B1-9397-1258FA8B1167_J2-B102/D4723176-33A4-4472-A4B6-17B027AE5FFC/D4723176-33A4-4472-A4B6-17B027AE5FFC-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-13",
              "Id": "378d4679-5026-4c67-8b65-ddf25fda0029",
              "CourseID": "5FD47BAE-A409-4732-A93C-8229B5965FB2",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.52:9091",
              "ThumbnailPath": "/20210513/761355C6-8C2C-44A8-891F-583F627AA46C_J2-B102/522A33CF-F6F6-420D-8BBB-612CF1C2A997/522A33CF-F6F6-420D-8BBB-612CF1C2A997-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-11",
              "Id": "ca6a9c5f-885f-4c8c-9c5c-0ff71eecf3f1",
              "CourseID": "19ECDC95-417E-4A54-8D26-686FCA9714AC",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.50:9091",
              "ThumbnailPath": "/20210511/54C29B8A-B8D6-4A54-971A-7EF4E7A53530_J2-B102/457A7F4A-3512-4AD8-A8D4-872BAEA9286C/457A7F4A-3512-4AD8-A8D4-872BAEA9286C-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-06",
              "Id": "5fe7b910-b51f-40df-a02c-8228c6d411c7",
              "CourseID": "25AFBB7A-6DE4-4EF6-BA67-0F8B4511FF61",
              "CourseCode": "82467468-C466-4D5A-A29E-78027611B624",
              "RoomId": "J2-B102",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.48:9091",
              "ThumbnailPath": "/20210506/0825E767-E5DA-4A27-A0AB-47F92E3DDD6A_J2-B102/D5562E53-4418-4D3A-BD98-1BAC2D94512E/D5562E53-4418-4D3A-BD98-1BAC2D94512E-1.jpg",
              "ComPliedCount": 0
            }
          ]
        },
        {
          "Course": {
            "SeatNum": 0,
            "FileStoreUrl": "http://121.248.108.57:9091",
            "ThumbnailPath": "/20210602/E1446B43-CD91-4EC5-89DC-95FB847C2D83_J2-B204/79D381F0-ADE6-4F3A-BCA7-636F1288813F/79D381F0-ADE6-4F3A-BCA7-636F1288813F-1.jpg",
            "SegmentList": null,
            "ID": "4cef3c7f-2fb8-433c-9c58-50c0335d55b0",
            "CourseID": "87865906-C714-4C4B-B6CA-369A67E73115",
            "CourseName": "计算机网络",
            "TeacherName": null,
            "TeacherID": "5D3E37D9-C77D-41E7-9D81-86D46C355433",
            "UserName": "李鸣",
            "RecommendName": null,
            "RoomID": "J2-B204",
            "CourseDate": "2021-06-02",
            "ShowCourseDate": "2021-06-02",
            "SegmentID": null,
            "Segment": 0,
            "SegmentLength": 0,
            "DepartmentID": null,
            "SchoolCourseID": null,
            "ClassName": null,
            "DeptName": null,
            "CollegeID": null,
            "RoomName": null,
            "StartTime": "0001-01-01",
            "EndTime": "0001-01-01",
            "StartTimeW": "0001-01-01",
            "EndTimeW": "0001-01-01",
            "CollegeName": null,
            "Description": null,
            "WeekNum": 0,
            "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
            "Term": 2,
            "ShowTerm": "第二学期",
            "SchoolYear": "2020-2021",
            "Score": 0,
            "IsSeason": 0,
            "Status": 0,
            "ShowStatus": "待审核",
            "ApplyTime": "0001-01-01",
            "Remark": null,
            "ComPliedCount": 0,
            "CourseStartTime": null,
            "ClassRoomType": null,
            "CameraName": null,
            "GroupName": null,
            "compliedlist": null,
            "MissionType": 0,
            "IsSource": 0,
            "IsEvaluation": 0,
            "EvaluationCount": 0,
            "Appraiser": null
          },
          "CourseDateList": [
            {
              "Date": "2021-06-02",
              "Id": "4cef3c7f-2fb8-433c-9c58-50c0335d55b0",
              "CourseID": "87865906-C714-4C4B-B6CA-369A67E73115",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210602/E1446B43-CD91-4EC5-89DC-95FB847C2D83_J2-B204/79D381F0-ADE6-4F3A-BCA7-636F1288813F/79D381F0-ADE6-4F3A-BCA7-636F1288813F-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-28",
              "Id": "ba470978-5a48-4c2b-ba02-57f98b04bc87",
              "CourseID": "A24898A3-2548-408E-B9AD-951190384B13",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.52:9091",
              "ThumbnailPath": "/20210528/5E9A6880-CAF8-4614-ABDB-FDBBD3E72AEB_J2-B204/C07CBB66-8D6E-45FA-98A7-6CA876CB3DD8/C07CBB66-8D6E-45FA-98A7-6CA876CB3DD8-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-26",
              "Id": "fc0c4f68-a957-4b05-a7e7-a470f76de3d3",
              "CourseID": "3424A672-10C4-419A-9AAD-B524B432FE6E",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.50:9091",
              "ThumbnailPath": "/20210526/892A7FAE-587B-40AA-AF42-627F3A87EC01_J2-B204/1E5D882F-0B09-4A3F-A54F-F1B1CF39D4DD/1E5D882F-0B09-4A3F-A54F-F1B1CF39D4DD-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-25",
              "Id": "85979985-d52b-4cba-85ea-514d6fe25381",
              "CourseID": "BA016329-C58B-43CC-816A-2113747679F5",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.47:9091",
              "ThumbnailPath": "/20210525/BDA71DA0-F87D-4B86-9B79-25FB4CB870C6_J2-B204/06E732F8-48E9-4C3E-99A0-534E346495A3/06E732F8-48E9-4C3E-99A0-534E346495A3-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-21",
              "Id": "abf235fc-8c3a-4e12-b7d9-88b035dc1d44",
              "CourseID": "C19672D3-32B9-4F66-B582-86657340448B",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.44:9091",
              "ThumbnailPath": "/20210521/3E78D9EF-F3C4-4AC9-B412-97C683748F35_J2-B204/A8D77DB5-84D7-4540-B5B1-EB12B4ADF7E8/A8D77DB5-84D7-4540-B5B1-EB12B4ADF7E8-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-19",
              "Id": "21a2d9d9-7e59-4052-b6fe-152f20469116",
              "CourseID": "440C5B04-E1B8-46D1-842A-519C76ACC3CA",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.55:9091",
              "ThumbnailPath": "/20210519/A6A6533F-B58E-4007-BF41-63B1664E7F94_J2-B204/93FF0728-70F4-4051-9275-8863A38A4D1E/93FF0728-70F4-4051-9275-8863A38A4D1E-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-18",
              "Id": "0f87ccdc-732c-4493-b790-900f58e59626",
              "CourseID": "E94270E2-9FF6-45FE-85DB-C317BEE69D47",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.57:9091",
              "ThumbnailPath": "/20210518/9D691161-9F49-4437-842C-B339DAAD3A56_J2-B204/2002B338-7EFB-41F7-86DD-538B41AE250C/2002B338-7EFB-41F7-86DD-538B41AE250C-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-14",
              "Id": "3e991021-ac4d-4b96-bb67-859187a29fe1",
              "CourseID": "2FC09AC2-582E-49F8-983F-427EB7616263",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.45:9091",
              "ThumbnailPath": "/20210514/9C2D8978-3713-4633-A24C-E72CE7BDA476_J2-B204/87BBBF81-BC9A-4D4B-A961-3DE347178652/87BBBF81-BC9A-4D4B-A961-3DE347178652-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-12",
              "Id": "6e2d587d-cd35-42bf-a83f-63e11e407c00",
              "CourseID": "85402FC3-CAC3-4A0D-BF71-ED9A9E648612",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.45:9091",
              "ThumbnailPath": "/20210512/332967D4-8739-4526-A6C8-ABB42C65359A_J2-B204/51719142-9A05-4198-A805-68692FE5EBAB/51719142-9A05-4198-A805-68692FE5EBAB-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-11",
              "Id": "c5f2c288-5080-4772-a6ae-5618837102d6",
              "CourseID": "B136D17B-8510-46E0-A9AA-8B3727F43FC6",
              "CourseCode": "5ADC58FB-75D3-4221-8276-D44218E08D87",
              "RoomId": "J2-B204",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.52:9091",
              "ThumbnailPath": "/20210511/DF120D58-DB7D-491D-AC59-54C624BB6578_J2-B204/B7D49C49-9C1C-4AD7-839A-3A4ACE18D195/B7D49C49-9C1C-4AD7-839A-3A4ACE18D195-1.jpg",
              "ComPliedCount": 0
            }
          ]
        },
        {
          "Course": {
            "SeatNum": 0,
            "FileStoreUrl": "http://121.248.108.53:9091",
            "ThumbnailPath": "/20210528/07695F72-FB19-4A7C-AD6A-B286C360BA8C_J4-C309/D319B617-42EC-4FF9-AFE9-BC97CCECC0EA/D319B617-42EC-4FF9-AFE9-BC97CCECC0EA-1.jpg",
            "SegmentList": null,
            "ID": "5c84174a-2cf1-417e-959c-c0b8c08dee37",
            "CourseID": "63E31C2B-AD20-45CF-B5A6-F4C2BA720161",
            "CourseName": "英语实践（4）",
            "TeacherName": null,
            "TeacherID": "795E3264-0577-4837-BFA8-12383B2041C2",
            "UserName": "吴迪",
            "RecommendName": null,
            "RoomID": "J4-C309",
            "CourseDate": "2021-05-28",
            "ShowCourseDate": "2021-05-28",
            "SegmentID": null,
            "Segment": 0,
            "SegmentLength": 0,
            "DepartmentID": null,
            "SchoolCourseID": null,
            "ClassName": null,
            "DeptName": null,
            "CollegeID": null,
            "RoomName": null,
            "StartTime": "0001-01-01",
            "EndTime": "0001-01-01",
            "StartTimeW": "0001-01-01",
            "EndTimeW": "0001-01-01",
            "CollegeName": null,
            "Description": null,
            "WeekNum": 0,
            "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
            "Term": 2,
            "ShowTerm": "第二学期",
            "SchoolYear": "2020-2021",
            "Score": 0,
            "IsSeason": 0,
            "Status": 0,
            "ShowStatus": "待审核",
            "ApplyTime": "0001-01-01",
            "Remark": null,
            "ComPliedCount": 0,
            "CourseStartTime": null,
            "ClassRoomType": null,
            "CameraName": null,
            "GroupName": null,
            "compliedlist": null,
            "MissionType": 0,
            "IsSource": 0,
            "IsEvaluation": 0,
            "EvaluationCount": 0,
            "Appraiser": null
          },
          "CourseDateList": [
            {
              "Date": "2021-05-28",
              "Id": "5c84174a-2cf1-417e-959c-c0b8c08dee37",
              "CourseID": "63E31C2B-AD20-45CF-B5A6-F4C2BA720161",
              "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
              "RoomId": "J4-C309",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.53:9091",
              "ThumbnailPath": "/20210528/07695F72-FB19-4A7C-AD6A-B286C360BA8C_J4-C309/D319B617-42EC-4FF9-AFE9-BC97CCECC0EA/D319B617-42EC-4FF9-AFE9-BC97CCECC0EA-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-25",
              "Id": "041e4977-858e-437d-bd34-974c526f72be",
              "CourseID": "14A63A0C-A545-4A1B-9161-966496AA6F39",
              "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
              "RoomId": "J4-C309",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.45:9091",
              "ThumbnailPath": "/20210525/9AD46791-E4D9-44D7-A2FB-B81D8EB43CCF_J4-C309/83F25A82-F970-4FD1-80C4-AFBD67CEA773/83F25A82-F970-4FD1-80C4-AFBD67CEA773-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-21",
              "Id": "d248ed53-9cb8-4015-80b4-75a7979f3000",
              "CourseID": "AC9FD129-9B90-4C0D-BFE4-7860BA3F8B6B",
              "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
              "RoomId": "J4-C309",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.56:9091",
              "ThumbnailPath": "/20210521/C6B5E121-1359-4027-A91A-49BAE198BB1D_J4-C309/9BD272B7-FD59-4DBF-A08A-9B4699DDB47A/9BD272B7-FD59-4DBF-A08A-9B4699DDB47A-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-18",
              "Id": "f968fa55-2fcf-4a4a-be19-de94f5f75b97",
              "CourseID": "CFFCC8A6-0C67-499E-9507-17AB527D078E",
              "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
              "RoomId": "J4-C309",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.52:9091",
              "ThumbnailPath": "/20210518/3BA9BEAE-C3E2-4F2F-8FBE-C7CE32D73F06_J4-C309/99375A32-54E8-4F33-90D6-48B2F2D9294B/99375A32-54E8-4F33-90D6-48B2F2D9294B-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-14",
              "Id": "5e6e091d-ddf7-423f-bc79-1d8a410868cc",
              "CourseID": "BECCF362-871E-4E8C-9DBE-88F62EA76C7A",
              "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
              "RoomId": "J4-C309",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.51:9091",
              "ThumbnailPath": "/20210514/8A980CBA-4197-4AC6-A668-C3BD0236D243_J4-C309/FEA07C70-552A-4BC9-B910-4C5C06438D2E/FEA07C70-552A-4BC9-B910-4C5C06438D2E-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-05-11",
              "Id": "d475f875-46d2-4df8-9370-85e99f7c09bc",
              "CourseID": "AAB8ACE3-ADD8-4EA8-9ED7-46F46B93567A",
              "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
              "RoomId": "J4-C309",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.56:9091",
              "ThumbnailPath": "/20210511/B5ADAC56-A055-4FFD-B629-4CB927D186D2_J4-C309/159B7C34-1630-49FB-8206-623860934DE8/159B7C34-1630-49FB-8206-623860934DE8-1.jpg",
              "ComPliedCount": 0
            },
            {
              "Date": "2021-04-27",
              "Id": "ff167b49-ef7e-4879-afe3-434689693959",
              "CourseID": "0A46EE80-258A-4A9C-83FB-8E5E85CDDFFD",
              "CourseCode": "0CC9EF30-33D1-4694-AB6C-5E66C3DD81D6",
              "RoomId": "J4-C309",
              "RoomName": null,
              "StartTime": null,
              "EndTime": null,
              "FileStoreUrl": "http://121.248.108.45:9091",
              "ThumbnailPath": "/20210427/3B88A824-9310-4962-9D3E-253179A77350_J4-C309/F04A0356-E91F-407A-895C-9CC8812C713D/F04A0356-E91F-407A-895C-9CC8812C713D-1.jpg",
              "ComPliedCount": 0
            }
          ]
        }
      ]
    };
    VideoInfo videoInfo = new VideoInfo();
    videoInfo = VideoInfo.fromJson(data);
  }
  //考试
  static Map<String,dynamic> parseExam(Map<String,dynamic> data){
    var exam_list = [];
    for(var single_data in data['items']){
      var item = {
        "local": single_data['cdbh'],
        "time": single_data['kssj'],
        "course": single_data['kcmc'],
        "type": single_data['ksmc'],
        "year": int.parse(single_data['kssj'].substring(0,4)),
        "month": int.parse(single_data['kssj'].substring(5,7)),
        "day": int.parse(single_data['kssj'].substring(8,10))
      };
      exam_list.add(item);
    }
    var result = {
      'data':exam_list
    };
    return result;
  }
  //成绩（包括补考无明细）
  static Map<String,dynamic> parseScoreAll(Map<String,dynamic> data){
    var grades_list = data['items'];
    var l1 = [];
    for(var a in grades_list){
      var d1 = {
        "courseName": a['kcmc'],
        "xuefen": a['xf'],
        "jidian": a['jd'],
        "zongping": a['bfzcj'],
        "type": a['ksxz'],
      };
      l1.add(d1);
    }
    return {
      'data':l1
    };
  }
  //成绩（有明细无补考）
  static Map<String,dynamic> parseScore(Map<String,dynamic> data){
    List bklt = [];
    var kd = {"xmcj":"0"};
    //用flag做标记
    var ps = false; // 平时成绩
    var qm = false; // 期末
    var sy = false; // 实验
    var qz = false; // 期中
    var pscj = {};
    var qzcj = {};
    var sycj = {};
    var qmcj = {};
    var zpcj = {};
    for(var single_data in data['items']){
      Map<String,dynamic> foda = {
        "courseName": single_data['kcmc'],
        "xuefen": single_data['xf'],
        "jidian": "5.0",
        "zongping": '100',
        "scoreDetail": []
      };
      if(single_data['xmblmc'].toString().contains('平时')){
        ps = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        pscj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc'].toString().contains('期中')){
        qz = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        qzcj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc'].toString().contains('实验')){
        sy = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        sycj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc'].toString().contains('期末')){
        qm = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        qmcj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc']=='总评'){
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        foda['zongping'] = single_data['xmcj'];
        if(_isNumeric(foda['zongping'])){
          var zongping = double.parse(foda['zongping']);
          if(zongping>=95&&zongping<=100) foda['jidian'] = '5.0';
          if(zongping>=90&&zongping<=94) foda['jidian'] = '4.5';
          if(zongping>=85&&zongping<=89) foda['jidian'] = '4.0';
          if(zongping>=82&&zongping<=84) foda['jidian'] = '3.5';
          if(zongping>=79&&zongping<=81) foda['jidian'] = '3.0';
          if(zongping>=75&&zongping<=77) foda['jidian'] = '2.8';
          if(zongping>=72&&zongping<=74) foda['jidian'] = '2.5';
          if(zongping>=68&&zongping<=71) foda['jidian'] = '2.5';
          if(zongping>=65&&zongping<=67) foda['jidian'] = '1.5';
          if(zongping>=60&&zongping<=64) foda['jidian'] = '1.0';
          if(zongping>=0&&zongping<60) foda['jidian'] = '0.0';
        }else{
          if (foda['zongping'] == '免修') foda['zongping'] = '100';
          if (foda['zongping'] == '优秀'){
            foda['zongping'] = '90';
            foda['jidian'] = "4.5";
          }
          if (foda['zongping'] == '良好'){
            foda['zongping'] = '85';
            foda['jidian'] = "3.5";
          }
          if (foda['zongping'] == '中等'){
            foda['zongping'] = '75';
            foda['jidian'] = "2.5";
          }
          if (foda['zongping'] == '合格'||foda['zongping'] == '及格'){
            foda['zongping'] = '65';
            foda['jidian'] = "1.0";
          }
          if (foda['zongping'] == '不及格'){
            foda['zongping'] = '0';
            foda['jidian'] = "0.0";
          }
          if (foda['zongping'] == '未评价'){
            foda['zongping'] = '0';
            foda['jidain'] = "0.0";
          }
        }
        zpcj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
        if (ps){
          foda['scoreDetail'].add(pscj);
          ps = false;
        }
        if (qz){
          foda['scoreDetail'].add(qzcj);
          qz = false;
        }
        if (sy){
          foda['scoreDetail'].add(sycj);
          sy = false;
        }
        if (qm){
          foda['scoreDetail'].add(qmcj);
          qm = false;
        }
        foda['scoreDetail'].add(zpcj);
        ps = false;
        qz = false;
        sy = false;
        qm = false;
        bklt.add(foda);
      }
    }
    return {
      'data':bklt
    };
  }
  static bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}