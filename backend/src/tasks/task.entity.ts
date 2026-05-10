import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('tasks')
export class Task {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  title!: string;

  @Column()
  courseName!: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ type: 'int' })
  difficulty!: number;

  @Column({ type: 'timestamp' })
  deadline!: Date;

  @Column({ type: 'float', default: 0.0 })
  progress!: number;

  @Column({ type: 'float', default: 0.0 })
  priorityScore!: number;

  @Column({ default: false })
  isCompleted!: boolean;

  @CreateDateColumn()
  createdAt!: Date;
}