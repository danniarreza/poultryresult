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
  static final user_location_id = '_animal_location_id';
  static final user_management_location_id = '_management_location_id';

  static final _farm_sites_table = 'farm_sites';
  static final farm_sites_id = '_farm_sites_id';
  static final farm_sites_fst_type = 'farm_sites_fst_type';
  static final farm_sites_name = 'farm_sites_name';
  static final farm_sites_date_start = 'farm_sites_date_start';
  static final farm_sites_date_end = 'farm_sites_date_end';
  static final farm_sites_timezone = 'farm_sites_timezone';

  static final _animal_location_table = 'animal_location';
  static final animal_location_id = '_animal_location_id';
  static final animal_location_lcn_type = 'animal_location_lcn_type';
  static final animal_location_fst_id = 'animal_location_fst_id';
  static final animal_location_code = 'animal_location_code';
  static final animal_location_date_start = 'animal_location_date_start';
  static final animal_location_date_end = 'animal_location_date_end';

  static final _round_table = 'round';
  static final round_id = '_round_id';
  static final round_fst_id = 'round_fst_id';
  static final round_nr = 'round_nr';
  static final round_date_start = 'round_date_start';
  static final round_date_end = 'round_date_end';
  static final round_mutation_date = 'round_mutation_date';

  static final _management_location_table = 'management_location';
  static final management_location_id = '_management_location_id';
  static final management_location_animal_location_id = 'management_location_animal_location_id';
  static final management_location_round_id = 'management_location_round_id';
  static final management_location_code = 'management_location_code';
  static final management_location_date_start = 'management_location_date_start';
  static final management_location_date_end = 'management_location_date_end';
  static final management_location_mutation_date = 'management_location_mutation_date';

  static final _observed_animal_counts_table = 'observed_animal_count';
  static final observed_animal_counts_id = '_observed_animal_counts_id';
  static final observed_animal_counts_mln_id = 'observed_animal_counts_mln_id';
  static final observed_animal_counts_measurement_date = 'observed_animal_counts_measurement_date';
  static final observed_animal_counts_animals_in = 'observed_animal_counts_animals_in';
  static final observed_animal_counts_animals_out = 'observed_animal_counts_animals_out';
  static final observed_animal_counts_creation_date = 'observed_animal_counts_creation_date';
  static final observed_animal_counts_mutation_date = 'observed_animal_counts_mutation_date';
  static final observed_animal_counts_observed_by = 'observed_animal_counts_observed_by';

  static final _observed_mortality_table = 'observed_mortality';
  static final observed_mortality_id = '_observed_mortality_id';
  static final observed_mortality_mln_id = 'observed_mortality_mln_id';
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
  static final observed_water_uses_mln_id = 'observed_water_uses_mln_id';
  static final observed_water_uses_measurement_date = 'observed_water_uses_measurement_date';
  static final observed_water_uses_amount  = 'observed_water_uses_amount';
  static final observed_water_uses_unit = 'observed_water_uses_unit';
  static final observed_water_uses_meter_reading = 'observed_water_uses_meter_reading';
  static final observed_water_uses_creation_date = 'observed_water_uses_creation_date';
  static final observed_water_uses_mutation_date = 'observed_water_uses_mutation_date';
  static final observed_water_uses_observed_by = 'observed_water_uses_observed_by';

  static final _observed_weight_table = 'observed_weight';
  static final observed_weight_id = '_observed_weight_id';
  static final observed_weight_mln_id = 'observed_weight_mln_id';
  static final observed_weight_measurement_date = 'observed_weight_measurement_date';
  static final observed_weight_weights  = 'observed_weight_weights';
  static final observed_weight_unit = 'observed_weight_unit';
  static final observed_weight_creation_date = 'observed_weight_creation_date';
  static final observed_weight_mutation_date = 'observed_weight_mutation_date';
  static final observed_weight_observed_by = 'observed_weight_observed_by';

  static final _input_types_table = 'input_types';
  static final input_types_id = '_input_types_id';
  static final input_types_fse_id = 'input_types_fse_id';
  static final input_types_ite_type = 'input_types_ite_type';
  static final input_types_code = 'input_types_code';
  static final input_types_description  = 'input_types_description';
  static final input_types_uom = 'input_types_uom';
  static final input_types_active = 'input_types_active';

  static final _observed_input_uses_table = 'observed_input_uses';
  static final observed_input_uses_id = '_observed_input_uses_id';
  static final observed_input_uses_mln_id = 'observed_input_uses_mln_id';
  static final observed_input_uses_oue_type = 'observed_input_uses_oue_type';
  static final observed_input_uses_measurement_date  = 'observed_input_uses_measurement_date';
  static final observed_input_uses_treatment_nr = 'observed_input_uses_treatment_nr';
  static final observed_input_uses_total_amount = 'observed_input_uses_total_amount';
  static final observed_input_uses_unit = 'observed_input_uses_unit';
  static final observed_input_uses_creation_date = 'observed_input_uses_creation_date';
  static final observed_input_uses_mutation_date = 'observed_input_uses_mutation_date';
  static final observed_input_uses_observed_by = 'observed_input_uses_observed_by';

  static final _observed_input_types_table = 'observed_input_types';
  static final observed_input_types_id = '_observed_input_types_id';
  static final observed_input_types_ite_id = 'observed_input_types_ite_id';
  static final observed_input_types_oue_id = 'observed_input_types_oue_id';
  static final observed_input_types_amount  = 'observed_input_types_amount';
  static final observed_input_types_creation_date = 'observed_input_types_creation_date';
  static final observed_input_types_mutation_date = 'observed_input_types_mutation_date';

  static final _observed_egg_production_table = 'observed_egg_production';
  static final observed_egg_production_id = '_observed_egg_production_id';
  static final observed_egg_production_mln_id = 'observed_egg_production_mln_id';
  static final observed_egg_production_measurement_date = 'observed_egg_production_measurement_date';
  static final observed_egg_production_first_quality = 'observed_egg_production_first_quality';
  static final observed_egg_production_second_quality  = 'observed_egg_production_second_quality';
  static final observed_egg_production_ground_eggs = 'observed_egg_production_ground_eggs';
  static final observed_egg_production_egg_weight = 'observed_egg_production_egg_weight';
  static final observed_egg_production_weight_unit = 'observed_egg_production_weight_unit';
  static final observed_egg_production_creation_date = 'observed_egg_production_creation_date';
  static final observed_egg_production_mutation_date = 'observed_egg_production_mutation_date';
  static final observed_egg_production_observed_by = 'observed_egg_production_observed_by';

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
      CREATE TABLE $_animal_location_table(
      $animal_location_id INTEGER PRIMARY KEY,
      $animal_location_lcn_type TEXT NOT NULL,
      $animal_location_fst_id INTEGER NOT NULL,
      $animal_location_code TEXT NOT NULL,
      $animal_location_date_start TEXT,
      $animal_location_date_end TEXT
      );
      '''
    );
    db.execute(
      '''
      CREATE TABLE $_round_table(
      $round_id TEXT PRIMARY KEY,
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
      $management_location_id TEXT PRIMARY KEY,
      $management_location_animal_location_id TEXT NOT NULL,
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
      $observed_animal_counts_id TEXT PRIMARY KEY,
      $observed_animal_counts_mln_id TEXT NOT NULL,
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
      $observed_mortality_id TEXT PRIMARY KEY,
      $observed_mortality_mln_id TEXT NOT NULL,
      $observed_mortality_observation_nr INTEGER NOT NULL,
      $observed_mortality_measurement_date TEXT NOT NULL,
      $observed_mortality_animals_dead INTEGER NOT NULL,
      $observed_mortality_animals_selection INTEGER NOT NULL,
      $observed_mortality_creation_date DATETIME,
      $observed_mortality_mutation_date TEXT,
      $observed_mortality_remark TEXT,
      $observed_mortality_observed_by TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_observed_water_uses_table(
      $observed_water_uses_id TEXT PRIMARY KEY,
      $observed_water_uses_mln_id TEXT NOT NULL,
      $observed_water_uses_measurement_date TEXT NOT NULL,
      $observed_water_uses_amount INTEGER NOT NULL,
      $observed_water_uses_unit TEXT NOT NULL,
      $observed_water_uses_meter_reading INTEGER,
      $observed_water_uses_creation_date DATETIME,
      $observed_water_uses_mutation_date TEXT,
      $observed_water_uses_observed_by TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_observed_weight_table(
      $observed_weight_id TEXT PRIMARY KEY,
      $observed_weight_mln_id TEXT NOT NULL,
      $observed_weight_measurement_date TEXT NOT NULL,
      $observed_weight_weights INTEGER NOT NULL,
      $observed_weight_unit TEXT NOT NULL,
      $observed_weight_creation_date DATETIME,
      $observed_weight_mutation_date TEXT,
      $observed_weight_observed_by TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_input_types_table(
      $input_types_id INTEGER PRIMARY KEY,
      $input_types_fse_id INTEGER,
      $input_types_ite_type TEXT NOT NULL,
      $input_types_code TEXT NOT NULL,
      $input_types_description TEXT NOT NULL,
      $input_types_uom TEXT NOT NULL,
      $input_types_active TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_observed_input_uses_table(
      $observed_input_uses_id TEXT PRIMARY KEY,
      $observed_input_uses_mln_id TEXT NOT NULL,
      $observed_input_uses_oue_type TEXT NOT NULL,
      $observed_input_uses_measurement_date TEXT NOT NULL,
      $observed_input_uses_treatment_nr INTEGER NOT NULL,
      $observed_input_uses_total_amount INTEGER,
      $observed_input_uses_unit TEXT,
      $observed_input_uses_creation_date TEXT NOT NULL,
      $observed_input_uses_mutation_date TEXT NOT NULL,
      $observed_input_uses_observed_by TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_observed_input_types_table(
      $observed_input_types_id TEXT PRIMARY KEY,
      $observed_input_types_ite_id INTEGER NOT NULL,
      $observed_input_types_oue_id INTEGER NOT NULL,
      $observed_input_types_amount INTEGER NOT NULL,
      $observed_input_types_creation_date TEXT NOT NULL,
      $observed_input_types_mutation_date TEXT
      );
      '''
    );

    db.execute(
        '''
      CREATE TABLE $_observed_egg_production_table(
      $observed_egg_production_id TEXT PRIMARY KEY,
      $observed_egg_production_mln_id TEXT NOT NULL,
      $observed_egg_production_measurement_date TEXT,
      $observed_egg_production_first_quality INTEGER,
      $observed_egg_production_second_quality INTEGER,
      $observed_egg_production_ground_eggs INTEGER,
      $observed_egg_production_egg_weight DOUBLE,
      $observed_egg_production_weight_unit TEXT,
      $observed_egg_production_creation_date TEXT,
      $observed_egg_production_mutation_date TEXT,
      $observed_egg_production_observed_by TEXT
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

  Future<List <Map<String, dynamic>>> getWhere(String tableName, List<String> whereColumns, List<dynamic> whereValues) async{
    Database db = await instance.database;

    String whereString = '';
    whereColumns.forEach((column) {

      if(whereString != ''){
        whereString = whereString + ' and ';
      }

      whereString = whereString + column + ' = ?';
    });

    return await db.query(tableName, where: whereString, whereArgs: whereValues);
  }

  Future<List <Map<String, dynamic>>> getById(String tableName, int id) async{
    Database db = await instance.database;
    String columnId = '_'+tableName+'_id';

    return await db.query(tableName, where: '$columnId = ?', whereArgs: [
      id
    ]);
  }


  Future<int> update(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    String columnId = '_'+tableName+'_id';
    var id = row[columnId];

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

  Future<int> deleteWhere(String tableName, List<String> whereColumns, List<dynamic> whereValues) async{
    Database db = await instance.database;

    String whereString = '';
    whereColumns.forEach((column) {

      if(whereString != ''){
        whereString = whereString + ' and ';
      }

      whereString = whereString + column + ' = ?';
    });

    return await db.delete(tableName, where: whereString, whereArgs: whereValues);
  }


}