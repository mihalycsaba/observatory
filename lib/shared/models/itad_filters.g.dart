// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itad_filters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MinMaxAdapter extends TypeAdapter<MinMax> {
  @override
  final int typeId = 9;

  @override
  MinMax read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MinMax(
      min: fields[0] as int?,
      max: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MinMax obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.min)
      ..writeByte(1)
      ..write(obj.max);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinMaxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ITADFiltersAdapter extends TypeAdapter<ITADFilters> {
  @override
  final int typeId = 8;

  @override
  ITADFilters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ITADFilters(
      price: fields[0] as MinMax?,
      cut: fields[1] as MinMax?,
      bundled: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ITADFilters obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.price)
      ..writeByte(1)
      ..write(obj.cut)
      ..writeByte(2)
      ..write(obj.bundled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ITADFiltersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MinMaxImpl _$$MinMaxImplFromJson(Map<String, dynamic> json) => _$MinMaxImpl(
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MinMaxImplToJson(_$MinMaxImpl instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

_$ITADFiltersImpl _$$ITADFiltersImplFromJson(Map<String, dynamic> json) =>
    _$ITADFiltersImpl(
      price: json['price'] == null
          ? null
          : MinMax.fromJson(json['price'] as Map<String, dynamic>),
      cut: json['cut'] == null
          ? null
          : MinMax.fromJson(json['cut'] as Map<String, dynamic>),
      bundled: json['bundled'] as bool?,
    );

Map<String, dynamic> _$$ITADFiltersImplToJson(_$ITADFiltersImpl instance) =>
    <String, dynamic>{
      'price': instance.price?.toJson(),
      'cut': instance.cut?.toJson(),
      'bundled': instance.bundled,
    };
