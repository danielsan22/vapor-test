import Vapor
import Leaf
import FluentSQLite
import Authentication

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure the rest of your application here
    
    // Leaf template engine
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    // SQLite
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    try services.register(FluentSQLiteProvider())
    
    // Authentication
    try services.register(AuthenticationProvider())
    
    var databaseConfig = DatabasesConfig()
    print(directoryConfig.workDir)
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)auth.db"), threadPool: nil)
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: User.self, database: .sqlite)
    migrationConfig.add(model: Message.self, database: .sqlite)
    services.register(migrationConfig)
    
    /*
    try services.register(FluentSQLiteProvider())
    let sqlite = try SQLiteDatabase(storage: .memory, threadPool: nil)
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Message.self, database: .sqlite)
    services.register(migrationConfig)
    
    */
    
}
