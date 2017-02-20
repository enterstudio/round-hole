global class DB_SavePointHelper {
	global SavePoint setSavePoint() {
		return Database.setSavePoint();
	}
	
	global void rollback(SavePoint savePoint) {
		Database.rollback(savePoint);
	}
}