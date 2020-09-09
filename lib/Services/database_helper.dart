import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;

  static final _userTable = 'user';
  static final user_id = '_user_id';
  static final user_name = 'user_name';
  static final user_password = 'user_password';
  static final user_farm_sites_id = '_farm_sites_id';
  static final user_location_id = '_location_id';
  static final user_management_location_id = '_management_location_id';

  static final _farm_sites_table = 'farm_sites';
  static final farm_sites_id = '_farm_sites_id';
  static final farm_sites_fst_type = 'farm_sites_fst_type';
  static final farm_sites_name = 'farm_sites_name';
  static final farm_sites_date_start = 'farm_sites_date_start';
  static final farm_sites_date_end = 'farm_sites_date_end';
  static final farm_sites_timezone = 'farm_sites_timezone';

  static final _location_table = 'location';
  static final location_id = '_location_id';
  static final location_lcn_type = 'location_lcn_type';
  static final location_fst_id = 'location_fst_id';
  static final location_code = 'location_code';
  static final location_date_start = 'location_date_start';
  static final location_date_end = 'location_date_end';

  static final _round_table = 'round';
  static final round_id = '_round_id';
  static final round_uu_id = 'round_uu_id';
  static final round_fst_id = 'round_fst_id';
  static final round_nr = 'round_nr';
  static final round_date_start = 'round_date_start';
  static final round_date_end = 'round_date_end';
  static final round_mutation_date = 'round_mutation_date';

  static final _management_location_table = 'management_location';
  static final management_location_id = '_management_location_id';
  static final management_location_uu_id = 'management_location_uu_id';
  static final management_location_location_id = 'management_location_location_id';
  static final management_location_round_id = 'management_location_round_id';
  static final management_location_code = 'management_location_code';
  static final management_location_date_start = 'management_location_date_start';
  static final management_location_date_end = 'management_location_date_end';
  static final management_location_mutation_date = 'management_location_mutation_date';

  static final _observed_animal_counts_table = 'observed_animal_count';
  static final observed_animal_counts_id = '_observed_animal_counts_id';
  static final observed_animal_counts_uu_id = 'observed_animal_counts_uu_id';
  static final observed_animal_counts_aln_id = 'observed_animal_counts_aln_id';
  static final observed_animal_counts_measurement_date = 'observed_animal_counts_measurement_date';
  static final observed_animal_counts_animals_in = 'observed_animal_counts_animals_in';
  static final observed_animal_counts_animals_out = 'observed_animal_counts_animals_out';
  static final observed_animal_counts_creation_date = 'observed_animal_counts_creation_date';
  static final observed_animal_counts_mutation_date = 'observed_animal_counts_mutation_date';
  static final observed_animal_counts_observed_by = 'observed_animal_counts_observed_by';

  static final _observed_mortality_table = 'observed_mortality';
  static final observed_mortality_id = '_observed_mortality_id';
  static final observed_mortality_uu_id = 'observed_mortality_uu_id';
  static final observed_mortality_aln_id = 'observed_mortality_aln_id';
  static final observed_mortality_observation_nr = 'observed_mortality_observation_nr';
  static final observed_mortality_measurement_date = 'observed_mortality_measurement_date';
  static final observed_mortality_animals_dead = 'observed_mortality_animals_dead';
  static final observed_mortality_animals_selection = 'observed_mortality_animals_selection';
  static final observed_mortality_creation_date = 'observed_mortality_creation_date';
  static final observed_mortality_mutation_date = 'observed_mortality_mutation_date';
  static final observed_mortality_remark = 'observed_mortality_remark';
  static final observed_mortality_observed_by = 'observed_mortality_observed_by';

  static final _observed_water_uses_table = 'observed_water_uses';
  static final observed_water_uses_id = '_observed_water_uses_id';
  static final observed_water_uses_uu_id = 'observed_water_uses_uu_id';
  static final observed_water_uses_aln_id = 'observed_water_uses_aln_id';
  static final observed_water_uses_measurement_date = 'observed_water_uses_measurement_date';
  static final observed_water_uses_amount  = 'observed_water_uses_amount';
  static final observed_water_uses_unit = 'observed_water_uses_unit';
  static final observed_water_uses_meter_reading = 'observed_water_uses_meter_reading';
  static final observed_water_uses_creation_date = 'observed_water_uses_creation_date';
  static final observed_water_uses_mutation_date = 'observed_water_uses_mutation_date';
  static final observed_water_uses_observed_by = 'observed_water_uses_observed_by';

  static final _observed_weight_table = 'observed_weight';
  static final observed_weight_id = '_observed_weight_id';
  static final observed_weight_uu_id = 'observed_weight_uu_id';
  static final observed_weight_aln_id = 'observed_weight_aln_id';
  static final observed_weight_measurement_date = 'observed_weight_measurement_date';
  static final observed_weight_amount  = 'observed_weight_amount';
  static final observed_weight_unit = 'observed_weight_unit';
  static final observed_weight_creation_date = 'observed_weight_creation_date';
  static final observed_weight_mutation_date = 'observed_weight_mutation_date';
  static final observed_weight_observed_by = 'observed_weight_observed_by';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if(_database != null){
      return _database;
    }

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase () async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate (Database db, int version) {
    db.execute(
      '''
      CREATE TABLE $_userTable(
      $user_id INTEGER PRIMARY KEY,
      $user_name TEXT NOT NULL,
      $user_password TEXT NOT NULL,
      $user_location_id INTEGER,
      $user_farm_sites_id INTEGER,
      $user_management_location_id INTEGER
      );
      '''
    );
    db.execute(
        '''
      CREATE TABLE $_farm_sites_table(
      $farm_sites_id INTEGER PRIMARY KEY,
      $farm_sites_fst_type TEXT NOT NULL,
      $farm_sites_name TEXT NOT NULL,
      $farm_sites_date_start TEXT NOT NULL,
      $farm_sites_date_end TEXT,
      $farm_sites_timezone TEXT
      );
      '''
    );
    db.execute(
      '''
      CREATE TABLE $_location_table(
      $location_id INTEGER PRIMARY KEY,
      $location_lcn_type TEXT NOT NULL,
      $location_fst_id INTEGER NOT NULL,
      $location_code TEXT NOT NULL,
      $location_date_start TEXT,
      $location_date_end TEXT
      );
      '''
    );
    db.execute(
      '''
      CREATE TABLE $_round_table(
      $round_id INTEGER PRIMARY KEY,
      $round_uu_id TEXT NOT NULL,
      $round_fst_id INTEGER NOT NULL,
      $round_nr INTEGER NOT NULL,
      $round_date_start TEXT,
      $round_date_end TEXT,
      $round_mutation_date TEXT
      );
      '''
    );
    db.execute(
      '''
      CREATE TABLE $_management_location_table(
      $management_location_id INTEGER PRIMARY KEY,
      $management_location_uu_id TEXT NOT NULL,
      $management_location_location_id INTEGER NOT NULL,
      $management_location_round_id INTEGER NOT NULL,
      $management_location_code TEXT,
      $management_location_date_start TEXT,
      $management_location_date_end TEXT,
      $management_location_mutation_date TEXT
      );
      '''
    );
    db.execute(
      '''
      CREATE TABLE $_observed_animal_counts_table(
      $observed_animal_counts_id INTEGER PRIMARY KEY,
      $observed_animal_counts_uu_id TEXT,
      $observed_animal_counts_aln_id INTEGER NOT NULL,
      $observed_animal_counts_measurement_date TEXT NOT NULL,
      $observed_animal_counts_animals_in INTEGER NOT NULL,
      $observed_animal_counts_animals_out INTEGER NOT NULL,
      $observed_animal_counts_creation_date TEXT,
      $observed_animal_counts_mutation_date TEXT,
      $observed_animal_counts_observed_by TEXT
      );
      '''
    );
    db.execute(
        '''
      CREATE TABLE $_observed_mortality_table(
      $observed_mortality_id INTEGER PRIMARY KEY,
      $observed_mortality_uu_id TEXT,
      $observed_mortality_aln_id INTEGER NOT NULL,
      $observed_mortality_observation_nr INTEGER NOT NULL,
      $observed_mortality_measurement_date TEXT NOT NULL,
      $observed_mortality_animals_dead INTEGER NOT NULL,
      $observed_mortality_animals_selection INTEGER NOT NULL,
      $observed_mortality_creation_date TEXT,
      $observed_mortality_mutation_date TEXT,
      $observed_mortality_remark TEXT,
      $observed_mortality_observed_by TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_observed_water_uses_table(
      $observed_water_uses_id INTEGER PRIMARY KEY,
      $observed_water_uses_uu_id TEXT,
      $observed_water_uses_aln_id INTEGER NOT NULL,
      $observed_water_uses_measurement_date TEXT NOT NULL,
      $observed_water_uses_amount INTEGER NOT NULL,
      $observed_water_uses_unit TEXT NOT NULL,
      $observed_water_uses_meter_reading INTEGER,
      $observed_water_uses_creation_date TEXT,
      $observed_water_uses_mutation_date TEXT,
      $observed_water_uses_observed_by TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_observed_weight_table(
      $observed_weight_id INTEGER PRIMARY KEY,
      $observed_weight_uu_id TEXT,
      $observed_weight_aln_id INTEGER NOT NULL,
      $observed_weight_measurement_date TEXT NOT NULL,
      $observed_weight_amount INTEGER NOT NULL,
      $observed_weight_unit TEXT NOT NULL,
      $observed_weight_creation_date TEXT,
      $observed_weight_mutation_date TEXT,
      $observed_weight_observed_by TEXT
      );
      '''
    );
  }

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;

    int id = await db.insert(tableName, row);
    return id;
  }

  Future<List <Map<String, dynamic>>> get(String tableName) async{
    Database db = await instance.database;

    return await db.query(tableName);
  }

  Future<List <Map<String, dynamic>>> getById(String tableName, int id) async{
    Database db = await instance.database;
    String columnId = '_'+tableName+'_id';

    return await db.query(tableName, where: '$columnId = ?', whereArgs: [
      id
    ]);
  }

  Future<List <Map<String, dynamic>>> getByReference(String referenceTableName, String refereeTableName, String referenceColumnName, int refereeTableId) async{
    Database db = await instance.database;
//    String referenceTableId = '_'+refereeTableName+'_id';

    return await db.query(referenceTableName, where: '$referenceColumnName = ?', whereArgs: [
      refereeTableId
    ]);
  }

  Future<int> update(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    String columnId = '_'+tableName+'_id';
    int id = row[columnId];

    var numRow = await db.update(tableName, row, where: '$columnId = ?', whereArgs: [
      id
    ]);

    return numRow;
  }

  Future<int> delete(String tableName) async{
    Database db = await instance.database;

    return await db.delete(tableName);
  }

  Future<int> deleteById(String tableName, int id) async{
    Database db = await instance.database;
    String columnId = '_'+tableName+'_id';

    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }


}