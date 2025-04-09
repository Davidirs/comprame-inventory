class ConversionRateModel {
  String? bcv;
  String? paralelo;
  String? promedio;
  int? dateParalelo;
  int? dateBcvFees;

  ConversionRateModel(
      {this.bcv,
      this.paralelo,
        this.promedio,
        this.dateParalelo,
        this.dateBcvFees,
        });

  ConversionRateModel.fromJson(Map<String, dynamic> json) {
    bcv = json['bcv'];
    paralelo = json['paralelo'];
    promedio = json['promedio'];
    dateParalelo = json['dateParalelo'];
    dateBcvFees = json['dateBcvFees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bcv'] = bcv;
    data['paralelo'] = paralelo;
    data['promedio'] = promedio;
    data['dateParalelo'] = dateParalelo;
    data['dateBcvFees'] = dateBcvFees;
    return data;
  }
}
