"""检查 OpenAI 兼容接口是否可以被 AutoGen 调用。"""

from __future__ import annotations

import asyncio

from autogen_agentchat.agents import AssistantAgent
from autogen_agentchat.conditions import MaxMessageTermination
from autogen_agentchat.teams import RoundRobinGroupChat
from autogen_agentchat.ui import Console

from common import build_model_client, load_settings


async def main() -> None:
    settings = load_settings()
    model_client = build_model_client(settings)
    agent = AssistantAgent(
        "ApiTestAgent",
        model_client=model_client,
        system_message="请只回复：API 测试成功。",
    )
    team = RoundRobinGroupChat([agent], termination_condition=MaxMessageTermination(2))
    try:
        await Console(team.run_stream(task="请测试模型连接。"))
    finally:
        await model_client.close()


if __name__ == "__main__":
    asyncio.run(main())
