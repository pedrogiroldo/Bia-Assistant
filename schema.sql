


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE TYPE "public"."Event Status" AS ENUM (
    'confirmed',
    'cancelled',
    'pending_confirmation'
);


ALTER TYPE "public"."Event Status" OWNER TO "postgres";


CREATE TYPE "public"."Message Direction" AS ENUM (
    'inbound',
    'outbound'
);


ALTER TYPE "public"."Message Direction" OWNER TO "postgres";


CREATE TYPE "public"."Messages Types" AS ENUM (
    'text',
    'audio',
    'image'
);


ALTER TYPE "public"."Messages Types" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."calendar_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "contact_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "calendar_event_id" "text" NOT NULL,
    "title" "text" NOT NULL,
    "start_at" timestamp without time zone NOT NULL,
    "end_at" timestamp without time zone NOT NULL,
    "status" "public"."Event Status" DEFAULT 'pending_confirmation'::"public"."Event Status" NOT NULL
);


ALTER TABLE "public"."calendar_events" OWNER TO "postgres";


COMMENT ON TABLE "public"."calendar_events" IS 'Created/managed events';



CREATE TABLE IF NOT EXISTS "public"."contacts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "phone_number" "text" NOT NULL,
    "name" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."contacts" OWNER TO "postgres";


COMMENT ON TABLE "public"."contacts" IS 'Identifies user by phone number';



CREATE TABLE IF NOT EXISTS "public"."errors" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "source_node" "text",
    "code" "text",
    "message" "text",
    "raw" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."errors" OWNER TO "postgres";


COMMENT ON TABLE "public"."errors" IS 'Log errors catched by n8n';



CREATE TABLE IF NOT EXISTS "public"."execution_logs" (
    "execution_id" "text" NOT NULL,
    "phone_number" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "raw_data" "jsonb" NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."execution_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."llm_runs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "model" "text" NOT NULL,
    "prompt_ version" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "success" boolean DEFAULT false NOT NULL,
    "message_id" "uuid",
    "raw_info" "jsonb"
);


ALTER TABLE "public"."llm_runs" OWNER TO "postgres";


COMMENT ON TABLE "public"."llm_runs" IS 'Track the llm calls';



CREATE TABLE IF NOT EXISTS "public"."messages_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "message_whatsapp_id" "text",
    "text" "text",
    "transcription" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "raw_payload" "jsonb" NOT NULL,
    "direction" "public"."Message Direction" NOT NULL,
    "type" "public"."Messages Types",
    "contact_id" "uuid",
    "image_description" "text"
);


ALTER TABLE "public"."messages_logs" OWNER TO "postgres";


COMMENT ON TABLE "public"."messages_logs" IS 'Inbound/outbond messages logs';



ALTER TABLE ONLY "public"."calendar_events"
    ADD CONSTRAINT "calendar_events_calendar_event_id_key" UNIQUE ("calendar_event_id");



ALTER TABLE ONLY "public"."calendar_events"
    ADD CONSTRAINT "calendar_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_pphone_number_key" UNIQUE ("phone_number");



ALTER TABLE ONLY "public"."errors"
    ADD CONSTRAINT "errors_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."execution_logs"
    ADD CONSTRAINT "execution_logs_execution_id_key" UNIQUE ("execution_id");



ALTER TABLE ONLY "public"."execution_logs"
    ADD CONSTRAINT "execution_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."llm_runs"
    ADD CONSTRAINT "llm_runs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."messages_logs"
    ADD CONSTRAINT "messages_logs_message_id_key" UNIQUE ("message_whatsapp_id");



ALTER TABLE ONLY "public"."messages_logs"
    ADD CONSTRAINT "messages_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."calendar_events"
    ADD CONSTRAINT "calendar_events_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "public"."contacts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."llm_runs"
    ADD CONSTRAINT "llm_runs_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."messages_logs"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."messages_logs"
    ADD CONSTRAINT "messages_logs_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "public"."contacts"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE "public"."calendar_events" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."contacts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."errors" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."execution_logs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."llm_runs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."messages_logs" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON TABLE "public"."calendar_events" TO "anon";
GRANT ALL ON TABLE "public"."calendar_events" TO "authenticated";
GRANT ALL ON TABLE "public"."calendar_events" TO "service_role";



GRANT ALL ON TABLE "public"."contacts" TO "anon";
GRANT ALL ON TABLE "public"."contacts" TO "authenticated";
GRANT ALL ON TABLE "public"."contacts" TO "service_role";



GRANT ALL ON TABLE "public"."errors" TO "anon";
GRANT ALL ON TABLE "public"."errors" TO "authenticated";
GRANT ALL ON TABLE "public"."errors" TO "service_role";



GRANT ALL ON TABLE "public"."execution_logs" TO "anon";
GRANT ALL ON TABLE "public"."execution_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."execution_logs" TO "service_role";



GRANT ALL ON TABLE "public"."llm_runs" TO "anon";
GRANT ALL ON TABLE "public"."llm_runs" TO "authenticated";
GRANT ALL ON TABLE "public"."llm_runs" TO "service_role";



GRANT ALL ON TABLE "public"."messages_logs" TO "anon";
GRANT ALL ON TABLE "public"."messages_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."messages_logs" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







