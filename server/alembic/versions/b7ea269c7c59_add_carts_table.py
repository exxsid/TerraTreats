"""add carts table

Revision ID: b7ea269c7c59
Revises: c31d845ffc9e
Create Date: 2024-04-20 11:07:22.496228

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'b7ea269c7c59'
down_revision: Union[str, None] = 'c31d845ffc9e'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
