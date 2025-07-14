class Temperatures {
  final int? communeId2Cap;
  final String? communeName2Cap;
  final int? id;
  final String? thoigian;
  final int? communeId;
  final String? communeName;
  final String? districtName;
  final String? provinceName;
  final double? luongmuatd;
  final double? luongmuadb;
  final double? luongmuatdDb;
  final String? nguycosatlo;
  final String? nguycoluquet;
  final String? nguonmuadubao;
  final int? sogiodubao;
  final String? nguoiCapnhat;
  final String? ngayCapnhat;
  final int? provinceRef;
  final String? provinceName2Cap;
  final double? lat;
  final double? lon;
  final int? mucsatlo;
  final int? rn;

  Temperatures({
    this.communeId2Cap,
    this.communeName2Cap,
    this.id,
    this.thoigian,
    this.communeId,
    this.communeName,
    this.districtName,
    this.provinceName,
    this.luongmuatd,
    this.luongmuadb,
    this.luongmuatdDb,
    this.nguycosatlo,
    this.nguycoluquet,
    this.nguonmuadubao,
    this.sogiodubao,
    this.nguoiCapnhat,
    this.ngayCapnhat,
    this.provinceRef,
    this.provinceName2Cap,
    this.lat,
    this.lon,
    this.mucsatlo,
    this.rn,
  });

  factory Temperatures.fromJson(Map<String, dynamic> json) => Temperatures(
        communeId2Cap: json['commune_id_2cap'],
        communeName2Cap: json['commune_name_2cap'],
        id: json['id'],
        thoigian: json['thoigian'],
        communeId: json['commune_id'],
        communeName: json['commune_name'],
        districtName: json['district_name'],
        provinceName: json['provinceName'],
        luongmuatd: json['luongmuatd']?.toDouble(),
        luongmuadb: json['luongmuadb']?.toDouble(),
        luongmuatdDb: json['luongmuatd_db']?.toDouble(),
        nguycosatlo: json['nguycosatlo'],
        nguycoluquet: json['nguycoluquet'],
        nguonmuadubao: json['nguonmuadubao'],
        sogiodubao: json['sogiodubao'],
        nguoiCapnhat: json['nguoi_capnhat'],
        ngayCapnhat: json['ngay_capnhat'],
        provinceRef: json['province_ref'],
        provinceName2Cap: json['provinceName_2cap'],
        lat: json['lat']?.toDouble(),
        lon: json['lon']?.toDouble(),
        mucsatlo: json['mucsatlo'],
        rn: json['rn'],
      );
}
