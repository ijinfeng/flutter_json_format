import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

class JSONFile {
  JSONFile(this.path, {this.mimeType, this.name});

  JSONFile.xfile(XFile file)
      : path = file.path,
        mimeType = file.mimeType,
        name = file.name;

  JSONFile.pickFile(PlatformFile file)
      : path = file.path ?? "",
        mimeType = null,
        name = file.name;

  final String path;
  final String? mimeType;
  String? name;
}


class ReplaceClassModel {
	int a = 0;
	String? name;
	ReplaceClassModel_dic? dic;
	String? address;
	ReplaceClassModel_empty? empty;
	List<ReplaceClassModel_objects>? objects;
	dynamic kong;
	List<List<List<ReplaceClassModel_taowa>>>? taowa;

ReplaceClassModel();

void fromJson(Map<String, dynamic>? json) {
	if (json == null) return;
	a = json['a'] ?? 0;
	name = json['name'];
	dic = ReplaceClassModel_dic()..fromJson(json['dic']);
	address = json['address'];
	empty = ReplaceClassModel_empty()..fromJson(json['empty']);
	objects = (json['objects'] as List).map((e) => ReplaceClassModel_objects()..fromJson(e)).toList();
	kong = json['kong'];
	taowa = (json['taowa'] as List).map((e) => (e as List).map((e) => (e as List).map((e) => ReplaceClassModel_taowa()..fromJson(e)).toList()).toList()).toList();
}

Map<String, dynamic> toJson() {
return {
	'a': a,
	'name': name,
	'dic': dic?.toJson(),
	'address': address,
	'empty': empty?.toJson(),
	'objects': objects?.map((e) => e.toJson()).toList(),
	'kong': kong,
	'taowa': taowa?.map((e) => e.map((e) => e.map((e) => e.toJson()).toList()).toList()).toList(),
};
}
}

class ReplaceClassModel_dic {
	bool bb = false;
	int cc = 0;
	List<String>? dd;
	ReplaceClassModel_dic_ee? ee;

ReplaceClassModel_dic();

void fromJson(Map<String, dynamic>? json) {
	if (json == null) return;
	bb = json['bb'] ?? false;
	cc = json['cc'] ?? 0;
	dd = json['dd'];
	ee = ReplaceClassModel_dic_ee()..fromJson(json['ee']);
}

Map<String, dynamic> toJson() {
return {
	'bb': bb,
	'cc': cc,
	'dd': dd,
	'ee': ee?.toJson(),
};
}
}

class ReplaceClassModel_dic_ee {
	bool ty = false;
	List? ll;
	ReplaceClassModel_dic_ee_uu? uu;

ReplaceClassModel_dic_ee();

void fromJson(Map<String, dynamic>? json) {
	if (json == null) return;
	ty = json['ty'] ?? false;
	ll = json['ll'];
	uu = ReplaceClassModel_dic_ee_uu()..fromJson(json['uu']);
}

Map<String, dynamic> toJson() {
return {
	'ty': ty,
	'll': ll,
	'uu': uu?.toJson(),
};
}
}

class ReplaceClassModel_dic_ee_uu {
	String? y;

ReplaceClassModel_dic_ee_uu();

void fromJson(Map<String, dynamic>? json) {
	if (json == null) return;
	y = json['y'];
}

Map<String, dynamic> toJson() {
return {
	'y': y,
};
}
}

class ReplaceClassModel_empty {

ReplaceClassModel_empty();

void fromJson(Map<String, dynamic>? json) {
	if (json == null) return;
}

Map<String, dynamic> toJson() {
return {
};
}
}

class ReplaceClassModel_objects {
	int x = 0;
	int y = 0;

ReplaceClassModel_objects();

void fromJson(Map<String, dynamic>? json) {
	if (json == null) return;
	x = json['x'] ?? 0;
	y = json['y'] ?? 0;
}

Map<String, dynamic> toJson() {
return {
	'x': x,
	'y': y,
};
}
}

class ReplaceClassModel_taowa {
	int ni = 0;
	int hao = 0;

ReplaceClassModel_taowa();

void fromJson(Map<String, dynamic>? json) {
	if (json == null) return;
	ni = json['ni'] ?? 0;
	hao = json['hao'] ?? 0;
}

Map<String, dynamic> toJson() {
return {
	'ni': ni,
	'hao': hao,
};
}
}