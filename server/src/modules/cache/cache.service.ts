import {
  Injectable,
  OnModuleInit,
  OnModuleDestroy,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

@Injectable()
export class CacheService implements OnModuleInit, OnModuleDestroy {
  private redisClient: Redis | null = null;

  constructor(private configService: ConfigService) { }

  onModuleInit() {
    try {
      const redisUrl = this.configService.get<string>('REDIS_URL');

      if (redisUrl) {
        // Production (Render + Upstash)
        this.redisClient = new Redis(redisUrl, {
          maxRetriesPerRequest: 1,
        });

        console.log('🔄 Connecting to Redis using REDIS_URL...');
      } else {
        // Local Development
        this.redisClient = new Redis({
          host: this.configService.get<string>('REDIS_HOST', 'localhost'),
          port: this.configService.get<number>('REDIS_PORT', 6379),
          maxRetriesPerRequest: 1,
        });

        console.log('🔄 Connecting to local Redis...');
      }

      this.redisClient.on('connect', () => {
        console.log('✅ Redis connected successfully');
      });

      this.redisClient.on('ready', () => {
        console.log('🚀 Redis is ready');
      });

      this.redisClient.on('error', (err) => {
        console.warn(
          '⚠️ Redis connection failed. Caching will be disabled.',
          err.message,
        );
      });
    } catch (error) {
      console.warn('⚠️ Redis initialization failed:', error);
    }
  }

  onModuleDestroy() {
    if (this.redisClient) {
      this.redisClient.disconnect();
      console.log('🔌 Redis disconnected');
    }
  }

  async get(key: string): Promise<string | null> {
    if (!this.redisClient || this.redisClient.status !== 'ready') {
      return null;
    }

    try {
      return await this.redisClient.get(key);
    } catch {
      return null;
    }
  }

  async set(
    key: string,
    value: any,
    ttlInSeconds?: number,
  ): Promise<void> {
    if (!this.redisClient || this.redisClient.status !== 'ready') {
      return;
    }

    try {
      const stringValue =
        typeof value === 'string'
          ? value
          : JSON.stringify(value);

      if (ttlInSeconds) {
        await this.redisClient.set(
          key,
          stringValue,
          'EX',
          ttlInSeconds,
        );
      } else {
        await this.redisClient.set(key, stringValue);
      }
    } catch {
      // Ignore cache errors
    }
  }

  async delete(key: string): Promise<void> {
    if (!this.redisClient || this.redisClient.status !== 'ready') {
      return;
    }

    try {
      await this.redisClient.del(key);
    } catch {
      // Ignore
    }
  }

  async clearPattern(pattern: string): Promise<void> {
    if (!this.redisClient || this.redisClient.status !== 'ready') {
      return;
    }

    try {
      const keys = await this.redisClient.keys(pattern);

      if (keys.length > 0) {
        await this.redisClient.del(...keys);
      }
    } catch {
      // Ignore
    }
  }
}