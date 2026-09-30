CREATE TABLE `admin_logs` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`report_id` integer NOT NULL,
	`admin_user_id` integer NOT NULL,
	`action_type` text NOT NULL,
	`remark` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`report_id`) REFERENCES `reports`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`admin_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `bank_accounts` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`suspect_id` integer NOT NULL,
	`account_number` text NOT NULL,
	`account_name` text NOT NULL,
	`bank_name` text NOT NULL,
	FOREIGN KEY (`suspect_id`) REFERENCES `suspects`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `bank_number_idx` ON `bank_accounts` (`account_number`);--> statement-breakpoint
CREATE TABLE `evidence` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`report_id` integer NOT NULL,
	`type` text NOT NULL,
	`file_key` text NOT NULL,
	`file_name` text NOT NULL,
	`content_type` text NOT NULL,
	`uploaded_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`report_id`) REFERENCES `reports`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `reports` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`reporter_user_id` integer NOT NULL,
	`suspect_id` integer NOT NULL,
	`incident_date` text NOT NULL,
	`damage_amount` real NOT NULL,
	`details` text NOT NULL,
	`status` text DEFAULT 'Pending' NOT NULL,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	`updated_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`reporter_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`suspect_id`) REFERENCES `suspects`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `sessions` (
	`token_hash` text PRIMARY KEY NOT NULL,
	`user_id` integer NOT NULL,
	`expires_at` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `suspect_phones` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`suspect_id` integer NOT NULL,
	`phone_number` text NOT NULL,
	FOREIGN KEY (`suspect_id`) REFERENCES `suspects`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `suspect_phone_idx` ON `suspect_phones` (`phone_number`);--> statement-breakpoint
CREATE TABLE `suspects` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`first_name` text NOT NULL,
	`last_name` text NOT NULL,
	`line_id` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`full_name` text NOT NULL,
	`phone` text NOT NULL,
	`password_hash` text NOT NULL,
	`role` text DEFAULT 'User' NOT NULL,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_phone_unique` ON `users` (`phone`);