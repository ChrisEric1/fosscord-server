import "reflect-metadata";
import { Column, Entity, JoinColumn, ManyToOne, OneToMany, Relation, RelationId } from "typeorm";
import { BaseClass } from "./BaseClass";
import { TeamMember } from "./TeamMember";
import { User } from "./User";

@Entity("teams")
export class Team extends BaseClass {
	@Column({ nullable: true })
	icon?: string;

	@JoinColumn({ name: "member_ids" })
	@OneToMany(() => TeamMember, (member: TeamMember) => member.team, {
		orphanedRowAction: "delete"
	})
	members: Relation<TeamMember[]>;

	@Column()
	name: string;

	@Column({ nullable: true })
	@RelationId((team: Team) => team.owner_user)
	owner_user_id: string;

	@JoinColumn({ name: "owner_user_id" })
	@ManyToOne(() => User)
	owner_user: Relation<User>;
}
