import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { TasksModule } from './tasks/tasks.module';
import { Task } from './tasks/task.entity';

@Module({
  imports: [
    ConfigModule.forRoot(),
    // backend/src/app.module.ts
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'localhost',
      port: 3306,
      username: 'root',
      password: '', // COBA KOSONGKAN JIKA PAKAI XAMPP
      database: 'prioritask_db',
      entities: [Task],
      synchronize: true,
    }),
    TasksModule,
  ],
})
export class AppModule {}