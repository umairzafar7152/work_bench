import 'package:get_it/get_it.dart';
import 'package:work_bench/services/employee_job_service.dart';
import 'package:work_bench/services/employee_list_service.dart';
import 'package:work_bench/services/employer_flha_service.dart';
import 'package:work_bench/services/employer_inspection_service.dart';
import 'package:work_bench/services/equipment_service.dart';
import 'package:work_bench/services/flha_service.dart';
import 'package:work_bench/services/inspection_service.dart';
import 'package:work_bench/services/job_service.dart';
import 'package:work_bench/services/maintenance_service.dart';
import 'package:work_bench/services/planner_service.dart';
import 'package:work_bench/services/vehicle_service.dart';
import 'package:work_bench/view_models/employee_jobs_view_model.dart';
import 'package:work_bench/view_models/employee_list_view_model.dart';
import 'package:work_bench/view_models/employer_flha_view_model.dart';
import 'package:work_bench/view_models/employer_inspection_view_model.dart';
import 'package:work_bench/view_models/equipments_view_model.dart';
import 'package:work_bench/view_models/flha_view_model.dart';
import 'package:work_bench/view_models/inspection_view_model.dart';
import 'package:work_bench/view_models/jobs_view_model.dart';
import 'package:work_bench/view_models/planner_view_model.dart';
import 'package:work_bench/view_models/user_authentication_details.dart';
import 'package:work_bench/view_models/vehicles_view_model.dart';
import 'package:work_bench/view_models/maintenance_view_model.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<EquipmentService>(() => EquipmentService());
  serviceLocator.registerLazySingleton<VehicleService>(() => VehicleService());
  serviceLocator.registerLazySingleton<MaintenanceService>(() => MaintenanceService());
  serviceLocator.registerLazySingleton<JobService>(() => JobService());
  serviceLocator.registerLazySingleton<EmployeeListService>(() => EmployeeListService());
  serviceLocator.registerLazySingleton<InspectionService>(() => InspectionService());
  serviceLocator.registerLazySingleton<FlhaService>(() => FlhaService());
  // serviceLocator.registerLazySingleton<EmployeeCalendarService>(() => EmployeeCalendarService());
  serviceLocator.registerLazySingleton<PlannerService>(() => PlannerService());
  serviceLocator.registerLazySingleton<EmployeeJobService>(() => EmployeeJobService());
  serviceLocator.registerLazySingleton<EmployerFlhaService>(() => EmployerFlhaService());
  serviceLocator.registerLazySingleton<EmployerInspectionService>(() => EmployerInspectionService());

  serviceLocator.registerFactory<EquipmentsViewModel>(() => EquipmentsViewModel());
  serviceLocator.registerFactory<VehiclesViewModel>(() => VehiclesViewModel());
  serviceLocator.registerFactory<MaintenanceViewModel>(() => MaintenanceViewModel());
  serviceLocator.registerFactory<JobsViewModel>(() => JobsViewModel());
  serviceLocator.registerFactory<EmployeeListViewModel>(() => EmployeeListViewModel());
  serviceLocator.registerFactory<UserAuth>(() => UserAuth());
  serviceLocator.registerFactory<InspectionViewModel>(() => InspectionViewModel());
  serviceLocator.registerFactory<FlhaViewModel>(() => FlhaViewModel());
  // serviceLocator.registerFactory<EmployeeCalendarModel>(() => EmployeeCalendarModel());
  serviceLocator.registerFactory<PlannerViewModel>(() => PlannerViewModel());
  serviceLocator.registerFactory<EmployeeJobsViewModel>(() => EmployeeJobsViewModel());
  serviceLocator.registerFactory<EmployerFlhaViewModel>(() => EmployerFlhaViewModel());
  serviceLocator.registerFactory<EmployerInspectionViewModel>(() => EmployerInspectionViewModel());
}